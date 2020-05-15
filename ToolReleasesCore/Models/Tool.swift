//
//  Tool.swift
//  ToolReleasesCore
//
//  Created by Maris Lagzdins on 25/04/2020.
//  Copyright © 2020 Developer Maris. All rights reserved.
//

import FeedKit
import Foundation

public struct Tool: Identifiable {
    public let id = UUID()
    public let title: String
    public let description: String?
    public let url: URL?
    public let date: Date

    public init(title: String, link: URL, description: String, date: Date) {
        self.title = title
        self.url = link
        self.description = description
        self.date = date
    }

    public init?(_ item: RSSFeedItem) {
        guard let title = item.title else {
            return nil
        }

        guard let date = item.pubDate else {
            return nil
        }

        self.title = title
        self.description = item.description?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.date = date

        if let stringUrl = item.link {
            self.url = URL(string: stringUrl)
        } else {
            self.url = nil
        }
    }

    public var formattedDate: String {
        DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .none)
    }

    public var inBeta: Bool {
        title.contains("beta")
    }
}

extension Tool: Comparable {
    public static func < (lhs: Tool, rhs: Tool) -> Bool {
        lhs.date < rhs.date
    }
}

/*
      <title>macOS Catalina 10.15.5 beta 2 (19F62f)</title>
      <link>https://developer.apple.com/news/releases/?id=04162020a</link>
      <guid>https://developer.apple.com/news/releases/?id=04162020a</guid>
      <description>macOS Catalina 10.15.5 beta 2 (19F62f)</description>
      <pubDate>Thu, 16 Apr 2020 10:00:00 PDT</pubDate>
      <content:encoded><![CDATA[macOS Catalina 10.15.5 beta 2 (19F62f)]]></content:encoded>
 */
