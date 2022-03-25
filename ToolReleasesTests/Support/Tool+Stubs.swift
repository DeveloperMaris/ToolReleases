//
//  Tool.swift
//  ToolReleasesTests
//
//  Created by Maris Lagzdins on 13/08/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import Foundation
import ToolReleasesCore

// MARK: - Helpers
extension Tool {
    static let stub = Tool.make(withTitle: "iOS 15.3 beta (19D5026g)")

    static func make(withTitle title: String) -> Self {
        Tool(
            id: "https://developer.apple.com/news/releases/?id=1234567890a",
            title: title,
            date: Date(),
            url: URL(string: "www.example.com"),
            description: "Tool Description"
        )
    }

    static func make(with date: Date) -> Self {
        Tool(
            id: "https://developer.apple.com/news/releases/?id=1234567890a",
            title: "Test tool (1234567890)",
            date: date,
            url: URL(string: "www.example.com"),
            description: "Tool Description"
        )
    }
}
