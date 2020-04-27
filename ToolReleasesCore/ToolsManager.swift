//
//  ReleaseManager.swift
//  ToolReleasesCore
//
//  Created by Maris Lagzdins on 25/04/2020.
//  Copyright © 2020 Developer Maris. All rights reserved.
//

import FeedKit
import Foundation

public enum ToolFilter: CaseIterable, CustomStringConvertible {
    case all
    case beta
    case released

    public var description: String {
        switch self {
        case .all:
            return "All"
        case .beta:
            return "Beta"
        case .released:
            return "Released"
        }
    }
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
    public private(set) var currentFilter: ToolFilter = .all

    public init() {
        self.privateQueue = DispatchQueue.global(qos: .userInitiated)
        self.parser = FeedParser(URL: url)
    }

    public func fetch() {
        parser.parseAsync(queue: privateQueue) { result in
            switch result {
            case .success(let feed):
                guard let items = feed.rssFeed?.items else {
                    return
                }

                var tools = [Tool]()

                for item in items {
                    let tool = Tool(
                        title: item.title ?? "N/A",
                        link: URL(string: item.link!)!,
                        description:
                        item.description!,
                        date: item.pubDate!
                    )
                    tools.append(tool)
                }

                self.tools = tools

            case .failure(let error):
                break
            }
        }
    }

    public func filter(_ filter: ToolFilter) {
        var toolsCopy = tools
        currentFilter = filter
        switch filter {
        case .all:
            break
        case .beta:
            toolsCopy = toolsCopy.filter { $0.inBeta == true }
        case .released:
            toolsCopy = toolsCopy.filter { $0.inBeta == false }
        }

        DispatchQueue.main.async {
            self.filteredTools = toolsCopy
            .sorted()
            .reversed()
        }
    }
}
