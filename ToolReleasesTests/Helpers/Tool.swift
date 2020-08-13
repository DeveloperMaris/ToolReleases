//
//  Tool.swift
//  ToolReleasesTests
//
//  Created by Maris Lagzdins on 13/08/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import ToolReleasesCore

// MARK: - Helpers
internal extension Tool {
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
