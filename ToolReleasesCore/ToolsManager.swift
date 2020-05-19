//
//  ReleaseManager.swift
//  ToolReleasesCore
//
//  Created by Maris Lagzdins on 25/04/2020.
//  Copyright © 2020 Developer Maris. All rights reserved.
//

import FeedKit
import Foundation

public class ToolsManager: ObservableObject {
    let url = URL(string: "https://developer.apple.com/news/releases/rss/releases.rss")!
    let parser: FeedParser
    let privateQueue: DispatchQueue

    @Published public private(set) var tools = [Tool]()

    public init() {
        self.privateQueue = DispatchQueue.global(qos: .userInitiated)
        self.parser = FeedParser(URL: url)
    }

    public func fetch() {
        parser.parseAsync(queue: privateQueue) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let feed):
                guard let items = feed.rssFeed?.items else {
                    return
                }

                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.tools = items.compactMap { item in
                        if let tool = Tool(item), self.isTool(tool.title) {
                            return tool
                        }
                        return nil
                    }
                }

            case .failure:
                break
            }
        }
    }

    func isTool(_ tool: String) -> Bool {
        let range = NSRange(location: 0, length: tool.utf16.count)
        let regex = try! NSRegularExpression(pattern: #"^.+\(.+\)$"#)
        return regex.firstMatch(in: tool, options: [], range: range) != nil
    }
}
