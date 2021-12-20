//
//  ToolProvider.swift
//  ToolReleasesCore
//
//  Created by Maris Lagzdins on 25/04/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import Combine
import FeedKit
import Foundation
import os.log

public class ToolProvider: ObservableObject {
    static private let logger = Logger(category: "ToolProvider")

    private let loader: ToolLoader
    private var cancellableAutomaticUpdates: AnyCancellable?
    private var autoCheckTimeInterval: TimeInterval = 3_600 // 1 hour
    // Last refresh date, meant for internal use only.
    private var internalLastRefresh: Date?

    private var newToolsSubject = PassthroughSubject<[Tool], Never>()

    internal let privateQueue: DispatchQueue
    internal let delegateQueue: DispatchQueue = .main

    @Published public private(set) var tools: [Tool] = []
    @Published public private(set) var lastRefresh: Date?
    @Published public private(set) var isRefreshing = false

    public lazy var newToolsPublisher: AnyPublisher<[Tool], Never> = newToolsSubject
        .receive(on: delegateQueue)
        .eraseToAnyPublisher()

    public init(loader: ToolLoader) {
        self.privateQueue = DispatchQueue(
            label: "com.developermaris.ToolReleases.Core",
            qos: .userInitiated
        )

        self.loader = loader
        loader.queue = privateQueue
    }

    public func fetch() {
        guard isRefreshing == false else {
            return
        }

        Self.logger.debug("Fetch tools")

        delegateQueue.async { [weak self] in
            self?.isRefreshing = true
        }

        loader.load { [weak self] tools in
            self?.privateQueue.async {
                defer {
                    self?.delegateQueue.async {
                        self?.isRefreshing = false
                    }
                }

                self?.process(tools)
            }
        }
    }

    public func enableAutomaticUpdates() {
        Self.logger.debug("\(#function, privacy: .public)")

        cancellableAutomaticUpdates = Timer
            .publish(every: autoCheckTimeInterval, tolerance: autoCheckTimeInterval / 4, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] input in
                guard let self = self else { return }

                guard self.isRefreshing == false else {
                    Self.logger.debug("Skip automatic refresh, it's already in progress.")
                    return
                }

                Self.logger.debug("Fetch tools automatically")
                self.fetch()
            }
    }

    public func unsubscribeFromAutomaticUpdates() {
        cancellableAutomaticUpdates = nil
    }
}

// MARK: - Private methods
private extension ToolProvider {
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
        if internalLastRefresh != nil {
            let changes = tools.difference(from: self.tools)
            changes.insertions.forEach { change in
                guard case let .insert(_, tool, _) = change else { return }
                newTools.append(tool)
            }
        }

        internalLastRefresh = Date()

        delegateQueue.async { [weak self] in
            guard let self = self else { return }

            // Refresh the date, when the last
            // response has been received.
            self.lastRefresh = Date()

            // Update tool list by providing all
            // available tools.
            self.tools = tools

            Self.logger.debug("Tools processed successfully")

            if newTools.isEmpty == false {
                Self.logger.debug("New releases available: \(newTools.description, privacy: .public)")

                self.newToolsSubject.send(newTools)
            }
        }
    }
}
