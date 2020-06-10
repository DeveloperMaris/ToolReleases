//
//  ReleaseManager.swift
//  ToolReleasesCore
//
//  Created by Maris Lagzdins on 25/04/2020.
//  Copyright © 2020 Developer Maris. All rights reserved.
//

import FeedKit
import Foundation
import os.log

public class ToolsManager: ObservableObject {
    let url = URL(string: "https://developer.apple.com/news/releases/rss/releases.rss")!
    let parser: FeedParser
    let privateQueue: DispatchQueue

    private var autoCheckTimer: Timer?
    private var autoCheckTimeInterval: TimeInterval = 3600 // 1 hour

    @Published public private(set) var tools = [Tool]()
    @Published public private(set) var isRefreshing = false
    @Published public private(set) var lastRefresh: Date?

    public init() {
        self.privateQueue = DispatchQueue.global(qos: .userInitiated)
        self.parser = FeedParser(URL: url)

        startAutoCheckTimer()
    }

    public func fetch() {
        os_log(.debug, log: .toolManager, "Begin fetching tool list")
        isRefreshing = true
        parser.parseAsync(queue: privateQueue) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let feed):
                guard let items = feed.rssFeed?.items else {
                    DispatchQueue.main.async {
                        self.isRefreshing = false
                        os_log(.error, log: .toolManager, "Tool list fetching failed, no RSS feed items are available")
                    }
                    return
                }

                os_log(.debug, log: .toolManager, "RSS feed fetched, now transforming into Tool model.\n%{PRIVATE}@", items.debugDescription)

                let tools = items.compactMap(Tool.init)

                DispatchQueue.main.async {
                    self.lastRefresh = Date()
                    self.tools = tools
                    self.isRefreshing = false
                    os_log(.debug, log: .toolManager, "Tool list fetching finished successfully")
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    self.isRefreshing = false
                    os_log(.error, log: .toolManager, "Tool list fetching failed, %{PUBLIC}@", error.localizedDescription)
                }
            }
        }
    }
}

private extension ToolsManager {
    func startAutoCheckTimer() {
        os_log(.debug, log: .toolManager, "%{PUBLIC}@", #function)

        autoCheckTimer?.invalidate()
        autoCheckTimer = Timer.scheduledTimer(withTimeInterval: autoCheckTimeInterval, repeats: true, block: { [weak self] _ in
            guard let self = self else {
                return
            }

            guard self.isRefreshing == false else {
                os_log(.debug, log: .toolManager, "Skipping automatic refreshing, tools are currently being refreshed already")
                return
            }

            os_log(.debug, log: .toolManager, "Automatic fetch executes")
            self.fetch()
        })

        autoCheckTimer?.tolerance = autoCheckTimeInterval / 2
    }
}
