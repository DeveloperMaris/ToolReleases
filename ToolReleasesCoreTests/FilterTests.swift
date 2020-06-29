//
//  FilterTests.swift
//  ToolReleasesCoreTests
//
//  Created by Maris Lagzdins on 06/06/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

@testable
import ToolReleasesCore
import XCTest

class FilterTests: XCTestCase {
    var release1: Tool!
    var release2: Tool!
    var beta1: Tool!
    var beta2: Tool!
    var gm1: Tool!

    override func setUpWithError() throws {
        release1 = Tool.make(withTitle: "iOS 10.0 (1)")
        release2 = Tool.make(withTitle: "macOS 11.0 (2)")
        beta1 = Tool.make(withTitle: "watchOS 12.0 beta (3)")
        beta2 = Tool.make(withTitle: "watchOS 12.1.1 beta (4)")
        gm1 = Tool.make(withTitle: "tvOS 13.0 GM seed (4)")
    }

    override func tearDownWithError() throws {
        release1 = nil
        release2 = nil
        beta1 = nil
        gm1 = nil
    }

    func testFilterToolArrayForRelease() {
        // Given
        let tools: [Tool] = [release1, release2, beta1, beta2, gm1]

        // When
        let result = tools.filtered(by: .release)

        // Then
        XCTAssertEqual(result.count, 2)
    }

    func testFilterToolArrayForBeta() {
        // Given
        let tools: [Tool] = [release1, release2, beta1, beta2, gm1]

        // When
        let result = tools.filtered(by: .beta)

        // Then
        XCTAssertEqual(result.count, 3)
    }

    func testFilterToolArrayForAll() {
        // Given
        let tools: [Tool] = [release1, release2, beta1, beta2, gm1]

        // When
        let result = tools.filtered(by: .all)

        // Then
        XCTAssertEqual(result.count, 5)
    }
}

// MARK: - Helpers
fileprivate extension Tool {
    static func make(withTitle title: String) -> Self {
        Tool(id: "https://developer.apple.com/news/releases/?id=1234567890a", title: title, date: Date(), url: URL(string: "www.example.com"), description: "Tool Description")
    }
}
