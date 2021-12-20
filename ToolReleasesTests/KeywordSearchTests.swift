//
//  KeywordSearchTests.swift
//  ToolReleasesTests
//
//  Created by Maris Lagzdins on 10/07/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

@testable
import ToolReleases
import ToolReleasesCore
import XCTest

final class SearchKeywordsTests: XCTestCase {
    func testKeywordTransformationReturnsCorrectly() {
        // Given
        let keywords = "iOS"
        let result = [
            Search.Group([
                Search.Group.Keyword("iOS")
            ])
        ]

        // When
        let sut = Search.transformKeywords(keywords)

        // Then
        XCTAssertEqual(sut, result)
    }

    func testKeywordTransformationThrowsExceptionFromEmptyStringInput() {
        // Given
        let keywords = ""
        let result = [Search.Group]()

        // When
        let sut = Search.transformKeywords(keywords)

        // Then
        XCTAssertEqual(sut, result)
    }

    func testKeywordTransformationSplits2WordsBySpaces() {
        // Given
        let keywords = "iOS Beta"
        let result = [
            Search.Group([
                Search.Group.Keyword("iOS"),
                Search.Group.Keyword("Beta")
            ])
        ]

        // When
        let sut = Search.transformKeywords(keywords)

        // Then
        XCTAssertEqual(sut, result)
    }

    func testKeywordTransformationSplits3WordsBySpaces() {
        // Given
        let keywords = "iOS 13 Beta"
        let result = [
            Search.Group([
                Search.Group.Keyword("iOS"),
                Search.Group.Keyword("13"),
                Search.Group.Keyword("Beta")
            ])
        ]

        // When
        let sut = Search.transformKeywords(keywords)

        // Then
        XCTAssertEqual(sut, result)
    }

    func testKeywordTransformationSeparatesKeywordsInGroupsBySemicolon() {
        // Given
        let keywords = "iOS;Xcode"
        let result = [
            Search.Group([
                Search.Group.Keyword("iOS")
            ]),
            Search.Group([
                Search.Group.Keyword("Xcode")
            ])
        ]

        // When
        let sut = Search.transformKeywords(keywords)

        // Then
        XCTAssertEqual(sut, result)
    }

    func testKeywordTransformationSeparatesKeywordsInGroupsBySemicolonWithMultiplePhrases() {
        // Given
        let keywords = "iOS Beta;Xcode 11"
        let result = [
            Search.Group([
                Search.Group.Keyword("iOS"),
                Search.Group.Keyword("Beta")
            ]),
            Search.Group([
                Search.Group.Keyword("Xcode"),
                Search.Group.Keyword("11")
            ])
        ]

        // When
        let sut = Search.transformKeywords(keywords)

        // Then
        XCTAssertEqual(sut, result)
    }

    func testKeywordTransformationWithOnlyOneSemicolonThrowsException() {
        // Given
        let keywords = ";"
        let result = [Search.Group]()

        // When
        let sut = Search.transformKeywords(keywords)

        // Then
        XCTAssertEqual(sut, result)
    }

    func testKeywordTransformationWithOneSemicolonAndTextDoesNotCreateKeywordGroups_1() {
        // Given
        let keywords = "iOS;"
        let result = [
            Search.Group([
                Search.Group.Keyword("iOS")
            ])
        ]

        // When
        let sut = Search.transformKeywords(keywords)

        // Then
        XCTAssertEqual(sut, result)
    }

    func testKeywordTransformationWithOneSemicolonAndTextDoesNotCreateKeywordGroups_2() {
        // Given
        let keywords = ";iOS"
        let result = [
            Search.Group([
                Search.Group.Keyword("iOS")
            ])
        ]

        // When
        let sut = Search.transformKeywords(keywords)

        // Then
        XCTAssertEqual(sut, result)
    }

    func testKeywordTransformationWithMultipleSemicolonsWithoutTextThrowsException() {
        // Given
        let keywords = ";;;"
        let result = [Search.Group]()

        // When
        let sut = Search.transformKeywords(keywords)

        // Then
        XCTAssertEqual(sut, result)
    }

    func testKeywordTransformationWithMultipleSemicolonsAndTextCreatesOneKeywordGroup_1() {
        // Given
        let keywords = "iOS;;;"
        let result = [
            Search.Group([
                Search.Group.Keyword("iOS")
            ])
        ]

        // When
        let sut = Search.transformKeywords(keywords)

        // Then
        XCTAssertEqual(sut, result)
    }

    func testKeywordTransformationWithMultipleSemicolonsAndTextCreatesOneKeywordGroup_2() {
        // Given
        let keywords = ";;;iOS"
        let result = [
            Search.Group([
                Search.Group.Keyword("iOS")
            ])
        ]

        // When
        let sut = Search.transformKeywords(keywords)

        // Then
        XCTAssertEqual(sut, result)
    }

    func testKeywordTransformationWithMultipleSpacesDoesNotCreateMultipleEmptyPhrases() {
        // Given
        let keywords = "iOS     Beta"
        let result = [
            Search.Group([
                Search.Group.Keyword("iOS"),
                Search.Group.Keyword("Beta")
            ])
        ]

        // When
        let sut = Search.transformKeywords(keywords)

        // Then
        XCTAssertEqual(sut, result)
    }

    func testKeywordTransformationWithMultipleSpacesAfterSemicolonDoesNotCreateMultipleEmptyPhraseGroups() {
        // Given
        let keywords = "iOS Beta;     "
        let result = [
            Search.Group([
                Search.Group.Keyword("iOS"),
                Search.Group.Keyword("Beta")
            ])
        ]

        // When
        let sut = Search.transformKeywords(keywords)

        // Then
        XCTAssertEqual(sut, result)
    }
}
