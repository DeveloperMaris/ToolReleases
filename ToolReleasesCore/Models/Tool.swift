//
//  Tool.swift
//  ToolReleasesCore
//
//  Created by Maris Lagzdins on 25/04/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import FeedKit
import Foundation

public struct Tool: Identifiable, Equatable, Hashable {
    public let id: String
    public let title: String
    public let shortTitle: String
    public let description: String?
    public let url: URL?
    public let date: Date
    public let isBeta: Bool
    public let isReleaseCandidate: Bool
    public let isRelease: Bool

    public init(id: String, title: String, date: Date, url: URL?, description: String?) {
        self.id = id
        self.title = title
        self.shortTitle = ""
        self.date = date
        self.url = url
        self.description = description

        let isBeta = Self.isBetaTool(title: title)
        let isRC = Self.isReleaseCandidateTool(title: title)

        self.isBeta = isBeta
        self.isReleaseCandidate = isRC
        self.isRelease = isBeta == false && isRC == false
    }

    public init?(_ item: RSSFeedItem) {
        guard let title = item.title?.trimmingCharacters(in: .whitespaces) else {
            return nil
        }

        guard Self.isTool(title) else {
            return nil
        }

        guard let date = item.pubDate else {
            return nil
        }

        self.id = title
        self.title = title
        self.shortTitle = String(title.prefix { $0 != "(" }).trimmingCharacters(in: .whitespacesAndNewlines)
        self.description = item.description?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.date = date

        if let stringUrl = item.link, let url = URL(string: stringUrl) {
            self.url = url
        } else {
            self.url = nil
        }

        let isBeta = Self.isBetaTool(title: title)
        let isRC = Self.isReleaseCandidateTool(title: title)

        self.isBeta = isBeta
        self.isReleaseCandidate = isRC
        self.isRelease = isBeta == false && isRC == false
    }

    internal static func isTool(_ title: String) -> Bool {
        let range = NSRange(location: 0, length: title.utf16.count)
        let regex = try! NSRegularExpression(pattern: #"^.+\(.+\)$"#)
        return regex.firstMatch(in: title, options: [], range: range) != nil
    }
}

private extension Tool {
    static func isBetaTool(title: String) -> Bool {
        let keywords = [" beta", "beta "]
        return keywords.contains(where: title.lowercased().contains)
    }

    static func isReleaseCandidateTool(title: String) -> Bool {
        let keywords = ["release candidate", " rc", "rc "]
        return keywords.contains(where: title.lowercased().contains)
    }
}

public extension Tool {
    static let example: Tool = {
        let components = DateComponents(second: -30)
        let date = Calendar.current.date(byAdding: components, to: Date())!

        return Tool(
            id: "iOS 14.0 (1234567890)",
            title: "iOS 14.0 (1234567890)",
            date: date,
            url: URL(string: "wwww.apple.com"),
            description: "New release of iOS 14.0"
        )
    }()
}

/*
 Example:
 <title>macOS Catalina 10.15.5 beta 2 (19F62f)</title>
 <link>https://developer.apple.com/news/releases/?id=04162020a</link>
 <guid>https://developer.apple.com/news/releases/?id=04162020a</guid>
 <description>macOS Catalina 10.15.5 beta 2 (19F62f)</description>
 <pubDate>Thu, 16 Apr 2020 10:00:00 PDT</pubDate>
 <content:encoded><![CDATA[macOS Catalina 10.15.5 beta 2 (19F62f)]]></content:encoded>
 */
