//
//  ToolManager.swift
//  ToolReleasesCore
//
//  Created by Maris Lagzdins on 25/04/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import Combine
import FeedKit
import Foundation
import os.log
import UserNotifications

public class ToolManager: ObservableObject {
    public static let current: ToolManager = .init()

    private let url = URL(string: "https://developer.apple.com/news/releases/rss/releases.rss")!
    private let notificationCenter: UNUserNotificationCenter
    private var cancellableAutomaticUpdates: AnyCancellable?
    private var autoCheckTimeInterval: TimeInterval = 3_600 // 1 hour

    internal let parser: FeedParser
    internal let privateQueue: DispatchQueue
    internal let delegateQueue: DispatchQueue = .main

    @Published public private(set) var tools: [Tool] = []
    @Published public private(set) var lastRefresh: Date?
    @Published public private(set) var isRefreshing = false
    @Published public private(set) var isNewReleaseAvailable = false

    public init(notificationCenter: UNUserNotificationCenter = .current()) {
        self.privateQueue = DispatchQueue(
            label: "com.developermaris.ToolReleases.Core",
            qos: .userInitiated
        )
        self.parser = FeedParser(URL: url)
        self.notificationCenter = notificationCenter
    }

    public func fetch() {
        os_log(.info, log: .toolManager, "Fetch tools")

        delegateQueue.async { [weak self] in
            self?.isRefreshing = true
        }

        parser.parseAsync(queue: privateQueue) { [weak self] result in
            guard let self = self else { return }

            defer {
                self.delegateQueue.async {
                    self.isRefreshing = false
                }
            }

            switch result {
            case .success(let feed):
                guard let items = feed.rssFeed?.items else {
                    self.process([])
                    os_log(.error, log: .toolManager, "Tool fetching failed, no information available.")
                    return
                }

                let tools = items.compactMap(Tool.init)

                os_log(.debug, log: .toolManager, "Tools fetched successfully: %{public}@.", tools.description)
                self.process(tools)

            case .failure(let error):
                os_log(.error, log: .toolManager, "Tool fetching failed, %{public}@.", error.localizedDescription)
                self.process([])
            }
        }
    }

    public func subscribeForAutomaticUpdates() {
        os_log(.debug, log: .toolManager, "%{public}@", #function)

        cancellableAutomaticUpdates = Timer
            .publish(every: autoCheckTimeInterval, tolerance: autoCheckTimeInterval / 4, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] input in
                guard let self = self else { return }

                guard self.isRefreshing == false else {
                    os_log(.debug, log: .toolManager, "Skip automatic refresh, it's already in progress.")
                    return
                }

                os_log(.debug, log: .toolManager, "Fetch tools automatically")
                self.fetch()
            }
    }

    public func unsubscribeFromAutomaticUpdates() {
        cancellableAutomaticUpdates = nil
    }
}

// MARK: - Private methods
private extension ToolManager {
    /// Process tool list, compare it to the previously available tools and determine if there are new releases available.
    ///
    /// If new releases are available, also initiate a local notification.
    /// - Parameter tools: Tool list
    func process(_ tools: [Tool]) {
        dispatchPrecondition(condition: .onQueue(privateQueue))

        /// Will contain the newly added tools compared to the previous tool list.
        var newTools: [Tool] = []

        // If the application just started,
        // the `lastRefresh` will be `nil`,
        // indicating that there is no
        // previous tool list available.
        // In this case, do not check for new
        // tool releases.
        if lastRefresh != nil {
            let changes = tools.difference(from: self.tools)
            changes.insertions.forEach { change in
                guard case let .insert(_, tool, _) = change else { return }
                newTools.append(tool)
            }
        }

        delegateQueue.async { [weak self] in
            guard let self = self else { return }

            // Refresh the date, when the last
            // response has been received.
            self.lastRefresh = Date()

            // Update tool list by providing all
            // available tools.
            self.tools = tools
            self.isNewReleaseAvailable = newTools.isEmpty == false

            os_log(.info, log: .toolManager, "Tools processed successfully")

            if self.isNewReleaseAvailable {
                os_log(.debug, log: .toolManager, "New releases available: %{public}@", newTools.description)

                self.addNotification(about: newTools) { _ in
                    os_log(.info, log: .toolManager, "Notification added")
                }
            }
        }
    }
}

// MARK: - Notification handling
private extension ToolManager {
    private static let notificationID = "tool-releases-new-versions-available"

    func addNotification(about tools: [Tool], completion: @escaping (Bool) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestNotifications { success in
                    if success {
                        self.placeNotification(for: tools, completion: completion)
                    } else {
                        self.delegateQueue.async {
                            completion(false)
                        }
                    }
                }
            case .authorized:
                self.placeNotification(for: tools, completion: completion)

            default:
                self.delegateQueue.async {
                    completion(false)
                }
            }
        }
    }

    func removeNotification(for tools: [Tool]) {
        let id = makeNotificationID(for: tools)
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }

    func requestNotifications(completion: @escaping (Bool) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            completion(granted)
        }
    }

    func placeNotification(for tools: [Tool], completion: @escaping (Bool) -> Void) {
        let content = UNMutableNotificationContent()
        content.title = "New versions available!"
        content.sound = .default

        // TODO: Add localization.
        switch tools.count {
        case 0:
            fatalError("Do not display notification for no new tools.")
        case 1:
            content.subtitle = "\(tools[0].shortTitle)"
        case 2:
            content.subtitle = "\(tools[0].shortTitle) and \(tools[1].shortTitle)"
        default:
            content.subtitle = "\(tools[0].shortTitle), \(tools[1].shortTitle) and more"
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let id = makeNotificationID(for: tools)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        notificationCenter.add(request) { [weak self] error in
            self?.delegateQueue.async {
                if error == nil {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }

    func makeNotificationID(for tools: [Tool]) -> String {
        "\(Self.notificationID)-\(tools.hashValue)"
    }
}
