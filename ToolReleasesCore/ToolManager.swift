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

public class ToolManager: ObservableObject {
    public static let current: ToolManager = .init()

    private let url = URL(string: "https://developer.apple.com/news/releases/rss/releases.rss")!
    private var autoCheckTimerCancellable: AnyCancellable?
    private var autoCheckTimeInterval: TimeInterval = 3600 // 1 hour

    internal let parser: FeedParser
    internal let privateQueue: DispatchQueue

    @Published public private(set) var tools: [Tool] = []
    @Published public private(set) var isRefreshing = false
    @Published public private(set) var lastRefresh: Date?
    @Published public private(set) var newReleasesAvailable = false

    public init() {
        self.privateQueue = DispatchQueue(
            label: "com.developermaris.ToolReleases.Core.ToolsManager",
            qos: .userInitiated
        )
        self.parser = FeedParser(URL: url)

        startAutoCheckTimer()
    }

    public func fetch(resultQueue: DispatchQueue = .main) {
        os_log(.debug, log: .toolManager, "%{public}@", #function)

        isRefreshing = true
        parser.parseAsync(queue: privateQueue) { [weak self] result in
            guard let self = self else {
                return
            }

            defer {
                resultQueue.async {
                    self.isRefreshing = false
                }
            }

            resultQueue.async {
                // Refresh the date when the last
                // response has been received.
                self.lastRefresh = Date()
            }

            switch result {
            case .success(let feed):
                guard let items = feed.rssFeed?.items else {
                    resultQueue.async {
                        self.newReleasesAvailable = false
                        os_log(.error, log: .toolManager, "Tool list fetching failed, no RSS feed items are available")
                    }
                    return
                }

                os_log(
                    .debug,
                    log: .toolManager,
                    "RSS feed fetched, now transforming into Tool model.\n%{public}@",
                    items.debugDescription
                )

                let tools = items.compactMap(Tool.init)

                let newReleases: Bool

                if self.lastRefresh == nil {
                    // If the application just started,
                    // we won't have any new releases
                    // available.
                    newReleases = false
                } else {
                    let difference = tools.difference(from: self.tools)
                    newReleases = difference.insertions.isEmpty == false
                }

                resultQueue.async {
                    self.tools = tools
                    self.newReleasesAvailable = newReleases
                    os_log(
                        .debug,
                        log: .toolManager,
                        "Tool list fetching finished successfully, contains new releases: %{public}@",
                        newReleases.description
                    )
                }

            case .failure(let error):
                resultQueue.async {
                    self.newReleasesAvailable = false
                    os_log(
                        .error,
                        log: .toolManager,
                        "Tool list fetching failed, %{public}@",
                        error.localizedDescription
                    )
                }
            }
        }
    }
}

private extension ToolManager {
    func startAutoCheckTimer() {
        os_log(.debug, log: .toolManager, "%{public}@", #function)

        autoCheckTimerCancellable = Timer
            .publish(every: autoCheckTimeInterval, tolerance: autoCheckTimeInterval / 4, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] input in
                guard let self = self else {
                    return
                }

                guard self.isRefreshing == false else {
                    os_log(
                        .debug,
                        log: .toolManager,
                        "Skipping automatic refreshing, tools are currently being refreshed already"
                    )
                    return
                }

                os_log(.debug, log: .toolManager, "Execute automatic Tool fetching")
                self.fetch()
            }
    }
}
