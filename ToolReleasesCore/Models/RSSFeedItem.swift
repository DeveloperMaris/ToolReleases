//
//  RSSFeedItem.swift
//  ToolReleasesCore
//
//  Created by Maris Lagzdins on 04/06/2020.
//  Copyright © 2020 Developer Maris. All rights reserved.
//

import FeedKit

extension RSSFeedItem: CustomDebugStringConvertible {
    public var debugDescription: String {
        """
        RSSFeedItem {
            title: \(title ?? ""),
            link: \(link ?? ""),
            description: \(description ?? ""),
            pubDate: \(pubDate?.description ?? ""),
        }
        """
    }
}
