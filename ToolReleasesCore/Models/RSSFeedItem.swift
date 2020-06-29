//
//  RSSFeedItem.swift
//  ToolReleasesCore
//
//  Created by Maris Lagzdins on 04/06/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import FeedKit

extension RSSFeedItem: CustomDebugStringConvertible {
    public var debugDescription: String {
        """
        RSSFeedItem {
            guid: \(guid?.value ?? ""),
            title: \(title ?? ""),
            link: \(link ?? ""),
            description: \(description ?? ""),
            pubDate: \(pubDate?.description ?? ""),
        }
        """
    }
}
