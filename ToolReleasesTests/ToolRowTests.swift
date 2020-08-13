//
//  ToolRowTests.swift
//  ToolReleasesTests
//
//  Created by Maris Lagzdins on 13/08/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import Combine
@testable
import ToolReleases
import ToolReleasesCore
import XCTest

class ToolRowTests: XCTestCase {
    var timer: Publishers.Autoconnect<Timer.TimerPublisher>!
    var actualDate: Date!

    override func setUp() {
        super.setUp()

        timer = Timer.publish(every: 3600, on: .main, in: .common).autoconnect()
        actualDate = {
            let calendar = Calendar.current
            let components = DateComponents(calendar: calendar, year: 2020, month: 8, day: 10, hour: 18, minute: 0, second: 0)
            return calendar.date(from: components)!
        }()
    }

    override func tearDown() {
        super.tearDown()

        timer.upstream.connect().cancel()
        timer = nil
        actualDate = nil
    }

    func testToolRowFormattedDateForToolReleases0SecondsAgo() {
        // Given
        let tool = Tool.make(with: actualDate)

        let sut = ToolRow(tool: tool, timer: timer)

        // When
        let result = sut.parseDate(tool.date, relativeTo: actualDate)

        // then
        XCTAssertEqual(result, "Just now")
    }

    func testToolRowFormattedDateForToolReleases30SecondsAgo() {
        // Given
        let component = DateComponents(second: -30)
        let date = Calendar.current.date(byAdding: component, to: actualDate)!
        let tool = Tool.make(with: date)

        let sut = ToolRow(tool: tool, timer: timer)

        // When
        let result = sut.parseDate(tool.date, relativeTo: actualDate)

        // then
        XCTAssertEqual(result, "Just now")
    }

    func testToolRowFormattedDateForToolReleases59SecondsAgo() {
        // Given
        let component = DateComponents(second: -59)
        let date = Calendar.current.date(byAdding: component, to: actualDate)!
        let tool = Tool.make(with: date)

        let sut = ToolRow(tool: tool, timer: timer)

        // When
        let result = sut.parseDate(tool.date, relativeTo: actualDate)

        // then
        XCTAssertEqual(result, "Just now")
    }

    func testToolRowFormattedDateForToolReleases1MinuteAgo() {
        // Given
        let component = DateComponents(minute: -1)
        let date = Calendar.current.date(byAdding: component, to: actualDate)!
        let tool = Tool.make(with: date)

        let sut = ToolRow(tool: tool, timer: timer)

        // When
        let result = sut.parseDate(tool.date, relativeTo: actualDate)

        // then
        XCTAssertEqual(result, "1 Minute Ago")
    }

    func testToolRowFormattedDateForToolReleases1HourAgo() {
        // Given
        let component = DateComponents(hour: -1)
        let date = Calendar.current.date(byAdding: component, to: actualDate)!
        let tool = Tool.make(with: date)

        let sut = ToolRow(tool: tool, timer: timer)

        // When
        let result = sut.parseDate(tool.date, relativeTo: actualDate)

        // then
        XCTAssertEqual(result, "1 Hour Ago")
    }

    func testToolRowFormattedDateForToolReleases2HourAgo() {
        // Given
        let component = DateComponents(hour: -2)
        let date = Calendar.current.date(byAdding: component, to: actualDate)!
        let tool = Tool.make(with: date)

        let sut = ToolRow(tool: tool, timer: timer)

        // When
        let result = sut.parseDate(tool.date, relativeTo: actualDate)

        // then
        XCTAssertEqual(result, "2 Hours Ago")
    }

    func testToolRowFormattedDateForToolReleases16HourAgo() {
        // Given
        let component = DateComponents(hour: -16)
        let date = Calendar.current.date(byAdding: component, to: actualDate)!
        let tool = Tool.make(with: date)

        let sut = ToolRow(tool: tool, timer: timer)

        // When
        let result = sut.parseDate(tool.date, relativeTo: actualDate)

        // then
        XCTAssertEqual(result, "16 Hours Ago")
    }

    func testToolRowFormattedDateForToolReleasesAtMidnight() {
        // Given
        let component = DateComponents(hour: -18)
        let date = Calendar.current.date(byAdding: component, to: actualDate)!
        let tool = Tool.make(with: date)

        let sut = ToolRow(tool: tool, timer: timer)

        // When
        let result = sut.parseDate(tool.date, relativeTo: actualDate)

        // then
        XCTAssertEqual(result, "18 Hours Ago")
    }

    func testToolRowFormattedDateForToolReleases1SecondBeforeMidnight() {
        // Given
        let component = DateComponents(hour: -18, second: -1)
        let date = Calendar.current.date(byAdding: component, to: actualDate)!
        let tool = Tool.make(with: date)

        let sut = ToolRow(tool: tool, timer: timer)

        // When
        let result = sut.parseDate(tool.date, relativeTo: actualDate)

        // Then
        XCTAssertEqual(result, "1 Day Ago")
    }

    func testToolRowFormattedDateForToolReleases19HourAgo() {
        // Given
        let component = DateComponents(hour: -19)
        let date = Calendar.current.date(byAdding: component, to: actualDate)!
        let tool = Tool.make(with: date)

        let sut = ToolRow(tool: tool, timer: timer)

        // When
        let result = sut.parseDate(tool.date, relativeTo: actualDate)

        // then
        XCTAssertEqual(result, "1 Day Ago")
    }

    func testToolRowFormattedDateForToolReleases1DayAgo() {
        // Given
        let component = DateComponents(day: -1)
        let date = Calendar.current.date(byAdding: component, to: actualDate)!
        let tool = Tool.make(with: date)

        let sut = ToolRow(tool: tool, timer: timer)

        // When
        let result = sut.parseDate(tool.date, relativeTo: actualDate)

        // then
        XCTAssertEqual(result, "1 Day Ago")
    }

    func testToolRowFormattedDateForToolReleases6DaysAgo() {
        // Given
        let component = DateComponents(day: -6)
        let date = Calendar.current.date(byAdding: component, to: actualDate)!
        let tool = Tool.make(with: date)

        let sut = ToolRow(tool: tool, timer: timer)

        // When
        let result = sut.parseDate(tool.date, relativeTo: actualDate)

        // then
        XCTAssertEqual(result, "6 Days Ago")
    }

    func testToolRowFormattedDateForToolReleases6DaysAnd23HoursAgo() {
        // Given
        let component = DateComponents(day: -7, hour: 1)
        let date = Calendar.current.date(byAdding: component, to: actualDate)!
        let tool = Tool.make(with: date)

        let sut = ToolRow(tool: tool, timer: timer)

        // When
        let result = sut.parseDate(tool.date, relativeTo: actualDate)

        // then
        XCTAssertEqual(result, "1 Week Ago")
    }

    func testToolRowFormattedDateForToolReleases1WeekAgo() {
        // Given
        let component = DateComponents(day: -7)
        let date = Calendar.current.date(byAdding: component, to: actualDate)!
        let tool = Tool.make(with: date)

        let sut = ToolRow(tool: tool, timer: timer)

        // When
        let result = sut.parseDate(tool.date, relativeTo: actualDate)

        // then
        XCTAssertEqual(result, "1 Week Ago")
    }

    func testToolRowFormattedDateForToolReleases7DaysAnd1HoursAgo() {
        // Given
        let component = DateComponents(day: -7, hour: -1)
        let date = Calendar.current.date(byAdding: component, to: actualDate)!
        let tool = Tool.make(with: date)

        let sut = ToolRow(tool: tool, timer: timer)

        // When
        let result = sut.parseDate(tool.date, relativeTo: actualDate)

        // then
        XCTAssertEqual(result, "1 Week Ago")
    }

    func testToolRowFormattedDateForToolReleases2WeeksAgo() {
        // Given
        let component = DateComponents(day: -14)
        let date = Calendar.current.date(byAdding: component, to: actualDate)!
        let tool = Tool.make(with: date)

        let sut = ToolRow(tool: tool, timer: timer)

        // When
        let result = sut.parseDate(tool.date, relativeTo: actualDate)

        // then
        XCTAssertEqual(result, "2 Weeks Ago")
    }

    func testToolRowFormattedDateForToolReleases16DaysAgo() {
        // Given
        let component = DateComponents(day: -16)
        let date = Calendar.current.date(byAdding: component, to: actualDate)!
        let tool = Tool.make(with: date)

        let sut = ToolRow(tool: tool, timer: timer)

        // When
        let result = sut.parseDate(tool.date, relativeTo: actualDate)

        // then
        XCTAssertEqual(result, "2 Weeks Ago")
    }
}
