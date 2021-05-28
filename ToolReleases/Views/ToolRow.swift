//
//  ReleasedToolRow.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 09/05/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import Combine
import os.log
import SwiftUI
import ToolReleasesCore

struct ToolRow: View {
    private static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()

        formatter.dateStyle = .full
        formatter.timeStyle = .short

        return formatter
    }()

    let tool: Tool
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>

    @State private var currentDate = Date()

    private var isRecentRelease: Bool {
        DateComparison.isDate(tool.date, lessThan: 3, .day, since: currentDate)
    }

    var formattedDate: String {
        parseDate(tool.date, relativeTo: currentDate)
    }

    var body: some View {
        HStack {
            Text(tool.title)
                .font(.system(size: 12, weight: .medium, design: .default))
                .lineLimit(nil)

            Spacer()

            Text(formattedDate)
                .font(.system(size: 10, weight: isRecentRelease == true ? .bold : .light, design: .default))
                .foregroundColor(isRecentRelease == true ? Color("forestgreen") : .secondary)
                .lineLimit(1)
                .help(Self.fullDateFormatter.string(from: tool.date))
        }
        .padding([.vertical], 4)
        .onReceive(timer, perform: updateCurrentDate)
    }

    func updateCurrentDate(_ date: Date) {
        self.currentDate = date
        os_log(.debug, log: .views, "Tool date refreshed for %{public}@", self.tool.title)
    }

    /// Compares date times and produces a localized relative date time string
    ///
    /// Meant for comparing the Tool release date time with current date time and provide a localized string as "1 Hour Ago", etc.
    /// - Parameters:
    ///   - sourceDate: First date
    ///   - relativeDate: Date to which the first date will be compared
    /// - Returns: Localized relative date time format.
    internal func parseDate(_ sourceDate: Date, relativeTo relativeDate: Date) -> String {
        if DateComparison.isDate(sourceDate, lessThan: 1, .minute, since: relativeDate) {
            return "Just now"
        } else {
            // Remove exact time and leave only the date
            let sourceDateComponents = Calendar.current.dateComponents([.day, .month, .year], from: sourceDate)
            let relativeDateComponents = Calendar.current.dateComponents([.day, .month, .year], from: relativeDate)

            // Recreate the date object with only date available
            let sourceDateOnly = Calendar.current.date(from: sourceDateComponents) ?? sourceDate
            let relativeDateOnly = Calendar.current.date(from: relativeDateComponents) ?? relativeDate

            if DateComparison.isDate(sourceDateOnly, lessThan: 1, .day, since: relativeDateOnly) {
                // Show exact hour count only if the tool was released in the same day
                return RelativeDateTimeFormatter().localizedString(for: sourceDate, relativeTo: relativeDate).capitalized
            } else {
                // Take in count only the dates, not exact time
                return RelativeDateTimeFormatter().localizedString(for: sourceDateOnly, relativeTo: relativeDateOnly).capitalized
            }
        }
    }
}

struct ReleasedToolRow_Previews: PreviewProvider {
    static let tool: Tool = {
        let components = DateComponents(second: -30)
        let date = Calendar.current.date(byAdding: components, to: .now)!

        return Tool(
            id: "https://developer.apple.com/news/releases/?id=1234567890a",
            title: "iOS 14.0 (1234567890)",
            date: date,
            url: URL(string: "wwww.apple.com"),
            description: "New release of iOS 14.0"
        )
    }()

    static var previews: some View {
        ToolRow(tool: Self.tool, timer: Timer.publish(every: 1, on: .main, in: .common).autoconnect())
            .frame(width: 300)
    }
}
