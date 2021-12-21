//
//  ToolProviderTests.swift
//  ToolReleasesCoreTests
//
//  Created by Maris Lagzdins on 20/12/2021.
//  Copyright © 2021 Maris Lagzdins. All rights reserved.
//

import XCTest
@testable import ToolReleasesCore

final class ToolProviderTests: XCTestCase {
    func testFetchData() throws {
        // Given
        let tools = [Tool.stub]
        let loader = ToolLoaderMock()
        loader.mockTools = { tools }
        let sut = ToolProvider(loader: loader)

        let exp = expectation(description: "Tools are changed.")
        let cancelable = sut.$tools.dropFirst().sink { tools in
            exp.fulfill()
        }
        
        // When
        sut.fetch()

        // Then
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(sut.tools, tools)
    }
}

class ToolLoaderMock: ToolLoader {
    var mockTools: (() -> [Tool])?

    override func load(closure: @escaping ([Tool]) -> Void) {
        closure(mockTools?() ?? [])
    }
}
