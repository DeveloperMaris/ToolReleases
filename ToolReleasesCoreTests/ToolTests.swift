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
        let sut = Tool(id: UUID().uuidString, title: "Tool title", date: Date(), url: URL(string: "www.example.com"), description: "Tool Description")

        // Then
        XCTAssertNotNil(sut)
    }

    func testToolSuccessfulInitWithRSSFeedItem() {
        // Given
        let item = RSSFeedItem()
        item.guid = .default
        item.title = "iOS 13.0 (1)"
        item.link = "www.example.com"
        item.description = "iOS Release"
        item.pubDate = Date()

        // When
        let sut = Tool(item)

        // Then
        XCTAssertNotNil(sut)
    }

    func testToolInitWithRSSFeedItemWithoutGuid() {
        // Given
        let item = RSSFeedItem()
        item.guid = nil
        item.title = "iOS 13.0 (1)"
        item.link = "www.example.com"
        item.description = "iOS Release"
        item.pubDate = Date()

        // When
        let sut = Tool(item)

        // Then
        XCTAssertNil(sut)
    }

    func testToolInitWithRSSFeedItemWithEmptyGuid() {
        // Given
        let item = RSSFeedItem()
        item.guid = RSSFeedItemGUID()
        item.title = "iOS 13.0 (1)"
        item.link = "www.example.com"
        item.description = "iOS Release"
        item.pubDate = Date()

        // When
        let sut = Tool(item)

        // Then
        XCTAssertNil(sut)
    }

    func testToolInitWithRSSFeedItemWithoutTitle() {
        // Given
        let item = RSSFeedItem()
        item.guid = .default
        item.title = nil
        item.link = "www.example.com"
        item.description = "iOS Release"
        item.pubDate = Date()

        // When
        let sut = Tool(item)

        // Then
        XCTAssertNil(sut)
    }

    func testToolInitWithRSSFeedItemWithoutURL() {
        // Given
        let item = RSSFeedItem()
        item.guid = .default
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
        // Given
        let item = RSSFeedItem()
        item.guid = .default
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
        // Given
        let item = RSSFeedItem()
        item.guid = .default
        item.title = "iOS 13.0 (1)"
        item.link = "www.example.com"
        item.description = "iOS Release"
        item.pubDate = nil

        // When
        let sut = Tool(item)

        // Then
        XCTAssertNil(sut)
    }

    func testToolInitRemovesDescriptionWhitespace() throws {
        // Given
        let description = " iOS Release "

        let item = RSSFeedItem()
        item.guid = .default
        item.title = "iOS 13.0 (1)"
        item.link = "www.example.com"
        item.description = description
        item.pubDate = Date()

        // When
        let sut = try XCTUnwrap(Tool(item))

        // Then
        XCTAssertNotEqual(sut.description, description)
        XCTAssertEqual(sut.description, description.trimmingCharacters(in: .whitespaces))
    }

    func testToolInitDoesNotContainIncorrectURL() throws {
        // Given
        let url = "not a url"

        let item = RSSFeedItem()
        item.guid = .default
        item.title = "iOS 13.0 (1)"
        item.link = url
        item.description = "iOS Release"
        item.pubDate = Date()

        // When
        let sut = try XCTUnwrap(Tool(item))

        // Then
        XCTAssertNil(sut.url)
    }

    // MARK: - Is Release

    func testToolIsRelease() {
        // Given
        let title = "iOS 13.0 (1)"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertTrue(sut.isRelease)
    }

    func testToolIsReleaseWithoutBuildNumber() {
        // Given
        let title = "iOS 13.0"

        // When
        let sut = Tool.make(withTitle: title)


        // Then
        XCTAssertTrue(sut.isRelease)
    }

    // MARK: - Is Beta

    func testToolIsBeta() {
        // Given
        let title = "iOS 13.0 beta (1)"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertTrue(sut.isBeta)
    }

    func testToolIsNotBeta() {
        // Given
        let title = "iOS 13.0 (1)"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertFalse(sut.isBeta)
    }

    func testToolIsBetaCapitalized() {
        // Given
        let title = "iOS 13.0 Beta (1)"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertTrue(sut.isBeta)
    }

    func testToolIsBetaContainingKeywordAtTheBeginning() {
        // Given
        let title = "Beta iOS 13.0 (1)"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertTrue(sut.isBeta)
    }

    func testToolIsBetaContainingKeywordAtTheEnd() {
        // Given
        let title = "iOS 13.0 (1) beta"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertTrue(sut.isBeta)
    }

    func testToolIncludingBetaInTitle() {
        // Given
        let title = "Betatron 13.0 (1)"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertFalse(sut.isBeta)
    }

    // MARK: - Is GM Seed

    func testToolIsGMSeed() {
        // Given
        let title = "iOS 13.0 gm seed (1)"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertTrue(sut.isGMSeed)
    }

    func testToolIsNotGMSeed() {
        // Given
        let title = "iOS 13.0 (1)"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertFalse(sut.isGMSeed)
    }

    func testToolIsNotGMSeedWithIncorrectSpelling() {
        // Given
        let title = "iOS 13.0 GMSeed (1)"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertFalse(sut.isGMSeed)
    }

    func testToolIsGMSeedCapitalized() {
        // Given
        let title = "iOS 13.0 GM Seed (1)"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertTrue(sut.isGMSeed)
    }

    func testToolIsGMSeedContainingKeywordAtTheBeginning() {
        // Given
        let title = "GM seed iOS 13.0 (1)"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertTrue(sut.isGMSeed)
    }

    func testToolIsGMSeedContainingKeywordAtTheEnd() {
        // Given
        let title = "iOS 13.0 (1) GM seed"

        // When
        let sut = Tool.make(withTitle: title)

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

    // MARK: - Contains ID

    func testIDIsValid() throws {
        // Given
        let id = "1234567890a"
        let string = "https://developer.apple.com/news/releases/?id=\(id)"

        // When
        let result = try Tool.parseID(from: string)

        // Then
        XCTAssertEqual(result, id)
    }

    func testIDIsEmpty() {
        // Given
        let string = "https://developer.apple.com/news/releases/?id="

        // Then
        XCTAssertThrowsError(try Tool.parseID(from: string))
    }

    func testIDStringPatternIsIncorrect_1() {
        // Given
        let string = "https://developer.apple.com/news/releases/"

        // Then
        XCTAssertThrowsError(try Tool.parseID(from: string))
    }

    func testIDStringPatternIsIncorrect_2() {
        // Given
        let string = "hfjshfjkhsajkfhadslfhasffsaIDdkas"

        // Then
        XCTAssertThrowsError(try Tool.parseID(from: string))
    }
}

// MARK: - Helpers
fileprivate extension Tool {
    static func make(withTitle title: String) -> Self {
        Tool(id: "https://developer.apple.com/news/releases/?id=1234567890a", title: title, date: Date(), url: URL(string: "www.example.com"), description: "Tool Description")
    }
}

fileprivate extension RSSFeedItemGUID {
    static var `default`: RSSFeedItemGUID {
        let guid = RSSFeedItemGUID()

        guid.value = "https://developer.apple.com/news/releases/?id=1234567890a"

        return guid
    }
}
