//
//  ToolTests.swift
//  ToolReleasesCoreTests
//
//  Created by Maris Lagzdins on 06/06/2020.
//  Copyright © 2020 Developer Maris. All rights reserved.
//

import FeedKit
@testable
import ToolReleasesCore
import XCTest

class ToolTests: XCTestCase {

    // MARK: - Initialization

    func testToolInit() {
        // When
        let sut = Tool(title: "Test", link: URL(string: "www.example.com")!, description: "Test", date: Date())

        // Then
        XCTAssertNotNil(sut)
    }

    func testToolSuccessfulInitWithRSSFeedItem() {
        // Givne
        let item = RSSFeedItem()
        item.title = "iOS 13.0 (1)"
        item.link = "www.example.com"
        item.description = "iOS Release"
        item.pubDate = Date()

        // When
        let sut = Tool(item)

        // Then
        XCTAssertNotNil(sut)
    }

    func testToolInitWithRSSFeedItemWithoutTitle() {
        // Givne
        let item = RSSFeedItem()
        item.title = nil
        item.link = "www.example.com"
        item.description = "iOS Release"
        item.pubDate = Date()

        // When
        let sut = Tool(item)

        // Then
        XCTAssertNil(sut)
    }

    func testToolInitWithRSSFeedItemWithoutLink() {
        // Givne
        let item = RSSFeedItem()
        item.title = "iOS 13.0 (1)"
        item.link = nil
        item.description = "iOS Release"
        item.pubDate = Date()

        // When
        let sut = Tool(item)

        // Then
        XCTAssertNotNil(sut)
    }

    func testToolInitWithRSSFeedItemWithoutDescription() {
        // Givne
        let item = RSSFeedItem()
        item.title = "iOS 13.0 (1)"
        item.link = "www.example.com"
        item.description = nil
        item.pubDate = Date()

        // When
        let sut = Tool(item)

        // Then
        XCTAssertNotNil(sut)
    }

    func testToolInitWithRSSFeedItemWithoutDate() {
        // Givne
        let item = RSSFeedItem()
        item.title = "iOS 13.0 (1)"
        item.link = "www.example.com"
        item.description = "iOS Release"
        item.pubDate = nil

        // When
        let sut = Tool(item)

        // Then
        XCTAssertNil(sut)
    }

    func testToolInitRemovesDescriptionWhitespace() {
        // Givne
        let description = " iOS Release "
        let item = RSSFeedItem()
        item.title = "iOS 13.0 (1)"
        item.link = "www.example.com"
        item.description = description
        item.pubDate = Date()

        // When
        let sut = Tool(item)!

        // Then
        XCTAssertNotEqual(sut.description, description)
        XCTAssertEqual(sut.description, description.trimmingCharacters(in: .whitespaces))
    }

    func testToolInitDoesNotContainIncorrectURL() {
        // Givne
        let url = "not a url"
        let item = RSSFeedItem()
        item.title = "iOS 13.0 (1)"
        item.link = url
        item.description = "iOS Release"
        item.pubDate = Date()

        // When
        let sut = Tool(item)!

        // Then
        XCTAssertNotNil(sut)
        XCTAssertNil(sut.url)
    }

    // MARK: - Is Release

    func testToolIsRelease() {
        // Given
        let title = "iOS 13.0 (1)"

        // When
        let sut = Tool(title: title, link: URL(string: "www.example.com")!, description: "Description", date: Date())

        // Then
        XCTAssertTrue(sut.isRelease)
    }

    func testToolIsReleaseWithoutBuildNumber() {
        // Given
        let title = "iOS 13.0"

        // When
        let sut = Tool(title: title, link: URL(string: "www.example.com")!, description: "Description", date: Date())

        // Then
        XCTAssertTrue(sut.isRelease)
    }

    // MARK: - Is Beta

    func testToolIsBeta() {
        // Given
        let title = "iOS 13.0 beta (1)"

        // When
        let sut = Tool(title: title, link: URL(string: "www.example.com")!, description: "Description", date: Date())

        // Then
        XCTAssertTrue(sut.isBeta)
    }

    func testToolIsNotBeta() {
        // Given
        let title = "iOS 13.0 (1)"

        // When
        let sut = Tool(title: title, link: URL(string: "www.example.com")!, description: "Description", date: Date())

        // Then
        XCTAssertFalse(sut.isBeta)
    }

    func testToolIsBetaCapitalized() {
        // Given
        let title = "iOS 13.0 Beta (1)"

        // When
        let sut = Tool(title: title, link: URL(string: "www.example.com")!, description: "Description", date: Date())

        // Then
        XCTAssertTrue(sut.isBeta)
    }

    func testToolIsBetaContainingKeywordAtTheBeginning() {
        // Given
        let title = "Beta iOS 13.0 (1)"

        // When
        let sut = Tool(title: title, link: URL(string: "www.example.com")!, description: "Description", date: Date())

        // Then
        XCTAssertTrue(sut.isBeta)
    }

    func testToolIsBetaContainingKeywordAtTheEnd() {
        // Given
        let title = "iOS 13.0 (1) beta"

        // When
        let sut = Tool(title: title, link: URL(string: "www.example.com")!, description: "Description", date: Date())

        // Then
        XCTAssertTrue(sut.isBeta)
    }

    func testToolIncludingBetaInTitle() {
        // Given
        let title = "Betatron 13.0 (1)"

        // When
        let sut = Tool(title: title, link: URL(string: "www.example.com")!, description: "Description", date: Date())

        // Then
        XCTAssertFalse(sut.isBeta)
    }

    // MARK: - Is GM Seed

    func testToolIsGMSeed() {
        // Given
        let title = "iOS 13.0 gm seed (1)"

        // When
        let sut = Tool(title: title, link: URL(string: "www.example.com")!, description: "Description", date: Date())

        // Then
        XCTAssertTrue(sut.isGMSeed)
    }

    func testToolIsNotGMSeed() {
        // Given
        let title = "iOS 13.0 (1)"

        // When
        let sut = Tool(title: title, link: URL(string: "www.example.com")!, description: "Description", date: Date())

        // Then
        XCTAssertFalse(sut.isGMSeed)
    }

    func testToolIsNotGMSeedWithIncorrectSpelling() {
        // Given
        let title = "iOS 13.0 GMSeed (1)"

        // When
        let sut = Tool(title: title, link: URL(string: "www.example.com")!, description: "Description", date: Date())

        // Then
        XCTAssertFalse(sut.isGMSeed)
    }

    func testToolIsGMSeedCapitalized() {
        // Given
        let title = "iOS 13.0 GM Seed (1)"

        // When
        let sut = Tool(title: title, link: URL(string: "www.example.com")!, description: "Description", date: Date())

        // Then
        XCTAssertTrue(sut.isGMSeed)
    }

    func testToolIsGMSeedContainingKeywordAtTheBeginning() {
        // Given
        let title = "GM seed iOS 13.0 (1)"

        // When
        let sut = Tool(title: title, link: URL(string: "www.example.com")!, description: "Description", date: Date())

        // Then
        XCTAssertTrue(sut.isGMSeed)
    }

    func testToolIsGMSeedContainingKeywordAtTheEnd() {
        // Given
        let title = "iOS 13.0 (1) GM seed"

        // When
        let sut = Tool(title: title, link: URL(string: "www.example.com")!, description: "Description", date: Date())

        // Then
        XCTAssertTrue(sut.isGMSeed)
    }

    // MARK: - Is a tool

    func testIsToolWithBuildNumber() {
        // Given
        let title = "iOS 13.0 (1)"

        // When
        let result = Tool.isTool(title)

        // Then
        XCTAssertTrue(result)
    }

    func testIsToolWithLargeBuildNumber() {
        // Given
        let title = "iOS 13.0 (1234567890)"

        // When
        let result = Tool.isTool(title)

        // Then
        XCTAssertTrue(result)
    }

    func testIsToolWithLargeRandomBuildNumber() {
        // Given
        let title = "iOS 13.0 (\(UUID()))"

        // When
        let result = Tool.isTool(title)

        // Then
        XCTAssertTrue(result, "Title is not a Tool title: \(title)")
    }

    func testIsNotToolWithoutBuildNumber() {
        // Given
        let title = "iOS 13.0"

        // When
        let result = Tool.isTool(title)

        // Then
        XCTAssertFalse(result)
    }

    func testIsNotToolWithUnfinishedBuildNumber() {
        // Given
        let title = "iOS 13.0 (1"

        // When
        let result = Tool.isTool(title)

        // Then
        XCTAssertFalse(result)
    }

    func testIsNotToolWithUnfinishedBuildNumber_2() {
        // Given
        let title = "iOS 13.0 1)"

        // When
        let result = Tool.isTool(title)

        // Then
        XCTAssertFalse(result)
    }
}
