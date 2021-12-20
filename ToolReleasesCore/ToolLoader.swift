//
//  ToolLoader.swift
//  ToolReleasesCore
//
//  Created by Maris Lagzdins on 19/12/2021.
//  Copyright © 2021 Maris Lagzdins. All rights reserved.
//

import FeedKit
import Foundation
import os.log

public class ToolLoader {
    static private let logger = Logger(category: "ToolLoader")

    private let url = URL(string: "https://developer.apple.com/news/releases/rss/releases.rss")!
    private let parser: FeedParser
    var queue: DispatchQueue = .global(qos: .userInitiated)

    public init() {
        self.parser = FeedParser(URL: url)
    }

    func load(closure: @escaping ([Tool]) -> Void) {
        parser.parseAsync(queue: queue) { result in
            switch result {
            case .success(let feed):
                guard let items = feed.rssFeed?.items else {
                    closure([])
                    Self.logger.debug("Tool fetching failed, no information available.")
                    return
                }

                let tools = items.compactMap(Tool.init)

                Self.logger.debug("Tools fetched successfully: \(tools.description, privacy: .public).")
                closure(tools)

            case .failure(let error):
                Self.logger.debug("Tool fetching failed, \(error.localizedDescription, privacy: .public).")
                closure([])
            }
        }
    }
}
