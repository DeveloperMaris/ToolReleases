//
//  CalendarDateComparisonTests.swift
//  ToolReleasesTests
//
//  Created by Maris Lagzdins on 05/06/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

@testable
import ToolReleases
import ToolReleasesCore
import XCTest

class CalendarDateComparisonTests: XCTestCase {
    func testToollessThanOneHourAgo() {
        // Given
        let component = DateComponents(minute: 59)
        let date = Calendar.current.date(byAdding: component, to: Date())!

        // When
        let result = Calendar.current.isDateComponent(.hour, from: date, to: Date(), lessThan: 1)

        // then
        XCTAssertTrue(result)
    }

    func testToolReleasedMoreThanOneHourAgo() {
        // Given
        let component = DateComponents(minute: -61)
        let date = Calendar.current.date(byAdding: component, to: Date())!

        // When
        let result = Calendar.current.isDateComponent(.hour, from: date, to: Date(), lessThan: 1)

        // then
        XCTAssertFalse(result)
    }

    func testToollessThanOneDayAgo() {
        // Given
        let component = DateComponents(hour: -23)
        let date = Calendar.current.date(byAdding: component, to: Date())!

        // When
        let result = Calendar.current.isDateComponent(.day, from: date, to: Date(), lessThan: 1)

        // then
        XCTAssertTrue(result)
    }

    func testToolReleasedMoreThanOneDayAgo() {
        // Given
        let component = DateComponents(day: -1, hour: -1)
        let date = Calendar.current.date(byAdding: component, to: Date())!

        // When
        let result = Calendar.current.isDateComponent(.day, from: date, to: Date(), lessThan: 1)

        // then
        XCTAssertFalse(result)
    }

    func testToollessThanOneDayAgoInSecondPrecision() {
        // Given
        let component = DateComponents(day: -1, second: 1)
        let date = Calendar.current.date(byAdding: component, to: Date())!

        // When
        let result = Calendar.current.isDateComponent(.day, from: date, to: Date(), lessThan: 1)

        // then
        XCTAssertTrue(result)
    }

    func testToolReleasedMoreThanOneDayAgoInSecondPrecision() {
        // Given
        let component = DateComponents(day: -1, second: -1)
        let date = Calendar.current.date(byAdding: component, to: Date())!

        // When
        let result = Calendar.current.isDateComponent(.day, from: date, to: Date(), lessThan: 1)

        // then
        XCTAssertFalse(result)
    }

    func testToollessThanThreeDaysAgo() {
        // Given
        let component = DateComponents(day: -2)
        let date = Calendar.current.date(byAdding: component, to: Date())!

        // When
        let result = Calendar.current.isDateComponent(.day, from: date, to: Date(), lessThan: 3)

        // then
        XCTAssertTrue(result)
    }

    func testToolReleasedMoreThanThreeDaysAgo() {
        // Given
        let component = DateComponents(day: -4)
        let date = Calendar.current.date(byAdding: component, to: Date())!

        // When
        let result = Calendar.current.isDateComponent(.day, from: date, to: Date(), lessThan: 3)

        // then
        XCTAssertFalse(result)
    }

    func testToolReleasedInFuture() {
        // Given
        let component = DateComponents(month: 1)
        let date = Calendar.current.date(byAdding: component, to: Date())!

        // When
        let result = Calendar.current.isDateComponent(.day, from: date, to: Date(), lessThan: 3)

        // then
        XCTAssertFalse(result)
    }

    func testToolReleasedInPast() {
        // Given
        let component = DateComponents(month: -1)
        let date = Calendar.current.date(byAdding: component, to: Date())!

        // When
        let result = Calendar.current.isDateComponent(.day, from: date, to: Date(), lessThan: 3)

        // then
        XCTAssertFalse(result)
    }

    func testToollessThanOneDayAgoInSecondPrecisionWithProvidedSinceDate() {
        // Given
        let component = DateComponents(day: -5, second: 1)
        let date = Calendar.current.date(byAdding: component, to: Date())!

        let endComponent = DateComponents(day: -4)
        let endDate = Calendar.current.date(byAdding: endComponent, to: Date())!

        // When
        // Calculations must track that the difference is 59 minutes.
        let result = Calendar.current.isDateComponent(.day, from: date, to: endDate, lessThan: 1)

        // then
        XCTAssertTrue(result)
    }
}
