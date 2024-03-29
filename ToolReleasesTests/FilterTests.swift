//
//  FilterTests.swift
//  ToolReleasesCoreTests
//
//  Created by Maris Lagzdins on 06/06/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

@testable
import ToolReleases
import ToolReleasesCore
import XCTest

final class FilterTests: XCTestCase {
    var release1: Tool!
    var release2: Tool!
    var beta1: Tool!
    var beta2: Tool!
    var rc1: Tool!

    override func setUpWithError() throws {
        release1 = Tool.make(withTitle: "iOS 10.0 (1)")
        release2 = Tool.make(withTitle: "macOS 11.0 (2)")
        beta1 = Tool.make(withTitle: "watchOS 12.0 beta (3)")
        beta2 = Tool.make(withTitle: "watchOS 12.1.1 beta (4)")
        rc1 = Tool.make(withTitle: "tvOS 13.0 Release Candidate (4)")
    }

    override func tearDownWithError() throws {
        release1 = nil
        release2 = nil
        beta1 = nil
        rc1 = nil
    }

    func testFilterToolArrayForRelease() {
        // Given
        let tools: [Tool] = [release1, release2, beta1, beta2, rc1]

        // When
        let result = tools.filtered(by: .release)

        // Then
        XCTAssertEqual(result.count, 2)
    }

    func testFilterToolArrayForBeta() {
        // Given
        let tools: [Tool] = [release1, release2, beta1, beta2, rc1]

        // When
        let result = tools.filtered(by: .beta)

        // Then
        XCTAssertEqual(result.count, 3)
    }

    func testFilterToolArrayForAll() {
        // Given
        let tools: [Tool] = [release1, release2, beta1, beta2, rc1]

        // When
        let result = tools.filtered(by: .all)

        // Then
        XCTAssertEqual(result.count, 5)
    }
}
