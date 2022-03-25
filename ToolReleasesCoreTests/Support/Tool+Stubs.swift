//
//  Tool+Stubs.swift
//  ToolReleasesCoreTests
//
//  Created by Maris Lagzdins on 20/12/2021.
//  Copyright © 2021 Maris Lagzdins. All rights reserved.
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
}
