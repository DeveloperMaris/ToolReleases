//
//  Tool.swift
//  ToolReleasesCore
//
//  Created by Maris Lagzdins on 25/04/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import FeedKit
import Foundation

public struct Tool: Identifiable, Equatable {
    enum ToolError: Error {
        case noID
        case error(_ error: Error)
    }

    public let id: String
    public let title: String
    public let description: String?
    public let url: URL?
    public let date: Date

    public var isBeta: Bool {
        title.lowercased().contains("beta ") || title.lowercased().contains(" beta")
    }

    public var isGMSeed: Bool {
        title.lowercased().contains("gm seed")
    }

    public var isRelease: Bool {
        isBeta == false && isGMSeed == false
    }

    public init(id: String, title: String, date: Date, url: URL?, description: String?) {
        self.id = id
        self.title = title
        self.date = date
        self.url = url
        self.description = description
    }

    public init?(_ item: RSSFeedItem) {
        guard let guid = item.guid?.value, let id = try? Self.parseID(from: guid) else {
            return nil
        }

        guard let title = item.title else {
            return nil
        }

        guard Self.isTool(title) else {
            return nil
        }

        guard let date = item.pubDate else {
            return nil
        }

        self.id = id
        self.title = title
        self.description = item.description?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.date = date

        if let stringUrl = item.link, let url = URL(string: stringUrl) {
            self.url = url
        } else {
            self.url = nil
        }
    }

    internal static func isTool(_ title: String) -> Bool {
        let range = NSRange(location: 0, length: title.utf16.count)
        let regex = try! NSRegularExpression(pattern: #"^.+\(.+\)$"#)
        return regex.firstMatch(in: title, options: [], range: range) != nil
    }

    internal static func parseID(from string: String) throws -> String {
        let idGroupName = "id"

        let range = NSRange(location: 0, length: string.utf16.count)
        do {
            let regex = try NSRegularExpression(pattern: #"^.+id=(?<\#(idGroupName)>\w+).*$"#, options: .caseInsensitive)
            if let match = regex.firstMatch(in: string, options: [], range: range) {
                if let destinationRange = Range(match.range(withName: idGroupName), in: string) {
                    return String(string[destinationRange])
                }
            }
        } catch {
            throw ToolError.error(error)
        }

        throw ToolError.noID
    }
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
