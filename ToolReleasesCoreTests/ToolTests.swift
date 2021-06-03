//
//  ToolTests.swift
//  ToolReleasesCoreTests
//
//  Created by Maris Lagzdins on 06/06/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
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
        XCTAssertNotNil(sut)
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
        XCTAssertNotNil(sut)
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

    // MARK: - Is Release Candidate

    func testToolIsReleaseCandidate() {
        // Given
        let title = "iOS 13.0 release candidate (1)"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertTrue(sut.isReleaseCandidate)
    }

    func testToolIsNotReleaseCandidate() {
        // Given
        let title = "iOS 13.0 (1)"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertFalse(sut.isReleaseCandidate)
    }

    func testToolIsNotReleaseCandidateWithIncorrectSpelling() {
        // Given
        let title = "iOS 13.0 ReleaseCandidate (1)"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertFalse(sut.isReleaseCandidate)
    }

    func testToolIsReleaseCandidateCapitalized() {
        // Given
        let title = "iOS 13.0 Release Candidate (1)"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertTrue(sut.isReleaseCandidate)
    }

    func testToolIsReleaseCandidateContainingKeywordAtTheBeginning() {
        // Given
        let title = "Release Candidate iOS 13.0 (1)"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertTrue(sut.isReleaseCandidate)
    }

    func testToolIsReleaseCandidateContainingKeywordAtTheEnd() {
        // Given
        let title = "iOS 13.0 (1) Release Candidate"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertTrue(sut.isReleaseCandidate)
    }

    func testToolIsReleaseCandidateContainingShortKeywordInTheMiddle() {
        // Given
        let title = "iOS 13.0 RC (1)"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertTrue(sut.isReleaseCandidate)
    }

    func testToolIsReleaseCandidateContainingShortKeywordAtTheBeginning() {
        // Given
        let title = "RC iOS 13.0 (1)"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertTrue(sut.isReleaseCandidate)
    }

    func testToolIsReleaseCandidateContainingShortKeywordAtTheEnd() {
        // Given
        let title = "iOS 13.0 (1) RC"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertTrue(sut.isReleaseCandidate)
    }

    func testToolIsReleaseCandidateContainingShortKeywordInLowercase() {
        // Given
        let title = "iOS 13.0 rc (1)"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertTrue(sut.isReleaseCandidate)
    }

    func testToolIsReleaseCandidateContainingShortKeywordWithVersion() {
        // Given
        let title = "iOS 13.0 RC 2 (1)"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertTrue(sut.isReleaseCandidate)
    }

    func testToolIsNotReleaseCandidateContainingShortKeywordWithinDifferentKeywords() {
        // Given
        let title = "iOS 13.0 Overcomplicated (1)"

        // When
        let sut = Tool.make(withTitle: title)

        // Then
        XCTAssertFalse(sut.isReleaseCandidate)
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

    func testBigSurBeta3RSSFeedItem() {
        // Given
        let guid = RSSFeedItemGUID()
        guid.value = "https://developer.apple.com/news/releases/?id=07222020e"

        let item = RSSFeedItem()
        item.guid = guid
        item.title = " macOS Big Sur 11 beta 3 (20A5323l) "
        item.link = "https://developer.apple.com/news/releases/?id=07222020e"
        item.description = "Users on macOS Big Sur 10.16 beta 1 or 2 will see the full install image for macOS Big Sur 11 beta 3 in the Software Update panel, rather than a smaller incremental update image. To download the incremental update image, click “More Info…” in the Software Update panel. Either image can be used to install beta 3"

        let dateString = "2020-07-22 20:30:00 +0000"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date = formatter.date(from: dateString)

        item.pubDate = date

        // When
        let sut = Tool(item)

        // Then
        XCTAssertNotNil(sut)
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
