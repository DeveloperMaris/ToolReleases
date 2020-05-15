//
//  ReleaseManager.swift
//  ToolReleasesCore
//
//  Created by Maris Lagzdins on 25/04/2020.
//  Copyright © 2020 Developer Maris. All rights reserved.
//

import FeedKit
import Foundation

public enum ToolFilter: String, CaseIterable {
    case all = "All"
    case beta = "Beta"
    case released = "Released"
}

public enum ReleaseManagerError: Error {
    case couldNot
}

public class ToolsManager: ObservableObject {
    let url = URL(string: "https://developer.apple.com/news/releases/rss/releases.rss")!
    let parser: FeedParser
    let privateQueue: DispatchQueue

    private var tools = [Tool]() {
        didSet {
            filter(currentFilter)
        }
    }

    @Published public private(set) var filteredTools = [Tool]()
    @Published public var currentFilter: ToolFilter = .all

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

                self.tools = items.compactMap { item in
                    if let tool = Tool(item), self.isToolRelease(tool.title) {
                        return tool
                    }
                    return nil
                }

            case .failure:
                break
            }
        }
    }

    public func filter(_ newFilter: ToolFilter) {
        var toolsCopy = tools
        switch newFilter {
        case .all:
            break
        case .beta:
            toolsCopy = toolsCopy.filter { $0.inBeta == true }
        case .released:
            toolsCopy = toolsCopy.filter { $0.inBeta == false }
        }

        toolsCopy.sort()
        toolsCopy.reverse()

        DispatchQueue.main.async {
            self.currentFilter = newFilter
            self.filteredTools = toolsCopy
        }
    }

    func isToolRelease(_ tool: String) -> Bool {
        let range = NSRange(location: 0, length: tool.utf16.count)
        let regex = try! NSRegularExpression(pattern: #"^.+\(.+\)$"#)
        return regex.firstMatch(in: tool, options: [], range: range) != nil
    }
}
