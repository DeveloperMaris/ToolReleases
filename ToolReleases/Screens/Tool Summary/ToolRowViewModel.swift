//
//  ToolRowViewModel.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 02/06/2021.
//  Copyright © 2021 Maris Lagzdins. All rights reserved.
//

import Combine
import Foundation
import os.log
import ToolReleasesCore

extension ToolRowView {
    class ViewModel: ObservableObject {
        private static let fullDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            formatter.timeStyle = .short
            return formatter
        }()

        private static let relativeDateFormatter: RelativeDateTimeFormatter = {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            formatter.dateTimeStyle = .numeric
            formatter.formattingContext = .standalone
            return formatter
        }()

        /// Provides a number of days, which counts as a recent releases and will
        /// be used to calculate how many tools needs to be highlighted.
        private static let recentReleaseDays = 4

        private var cancellableTimer: AnyCancellable?

        let tool: Tool
        let timer: Publishers.Autoconnect<Timer.TimerPublisher>

        @Published var fullDate: String
        @Published var relativeDate: String
        @Published var isRecentRelease: Bool

        init(tool: Tool, timer: Publishers.Autoconnect<Timer.TimerPublisher>) {
            self.tool = tool
            self.timer = timer
            self.fullDate = Self.fullDateFormatter.string(from: tool.date)
            self.relativeDate = ""
            self.isRecentRelease = false

            self.relativeDate = self.relativeDate(against: Date())
            self.isRecentRelease = self.isRecentRelease(against: Date())
        }

        func subscribeForTimerUpdates() {
            os_log(.debug, log: .views, "Subscribe for timer updates; %{public}@", tool.title)
            cancellableTimer = timer.sink { [weak self] date in
                guard let self = self else {
                    return
                }

                self.relativeDate = self.relativeDate(against: date)
                self.isRecentRelease = self.isRecentRelease(against: date)
            }
        }

        func unsubscribeFromTimerUpdates() {
            os_log(.debug, log: .views, "Unsubscribe for timer updates; %{public}@", tool.title)
            cancellableTimer = nil
        }

        /// Compares date times and produces a localized relative date time string.
        ///
        /// Meant for comparing the Tool release date time with current date time and provide a localized string as "1 Hour Ago", etc.
        ///
        /// - Important: If the beginning date is Friday afternoon (11 PM) and the end date is Saturday morning (9AM), then it will
        /// be treated as a next day already. Method does not care if 24 hours have or have not passed, it checks the current days.
        /// - Parameters:
        ///   - date: Beginning date of comparison.
        ///   - relativeDate: End date of comparison.
        ///   - calendar: Calendar is used to calculate precise dates.
        /// - Returns: Localized relative date time format.
        func string(for date: Date, relativeTo relativeDate: Date, calendar: Calendar = .current) -> String {
            if DateComparison.isDate(date, lessThan: 1, .minute, since: relativeDate) {
                return "Just now"
            } else {
                // Remove exact time and leave only the date
                let sourceDateComponents = calendar.dateComponents([.day, .month, .year], from: date)
                let relativeDateComponents = calendar.dateComponents([.day, .month, .year], from: relativeDate)

                // Recreate the date object with only date available
                let sourceDateOnly = calendar.date(from: sourceDateComponents) ?? date
                let relativeDateOnly = calendar.date(from: relativeDateComponents) ?? relativeDate

                if DateComparison.isDate(sourceDateOnly, lessThan: 1, .day, since: relativeDateOnly) {
                    // Show exact hour count only if the tool was released in the same day
                    return Self.relativeDateFormatter.localizedString(for: date, relativeTo: relativeDate).capitalized
                } else {
                    // Take in count only the dates, not exact time
                    return Self.relativeDateFormatter.localizedString(for: sourceDateOnly, relativeTo: relativeDateOnly).capitalized
                }
            }
        }

        deinit {
            unsubscribeFromTimerUpdates()
        }
    }
}

private extension ToolRowView.ViewModel {
    func relativeDate(against date: Date) -> String {
        string(for: tool.date, relativeTo: date)
    }

    func isRecentRelease(against date: Date) -> Bool {
        DateComparison.isDate(tool.date, lessThan: Self.recentReleaseDays, .day, since: date)
    }
}
