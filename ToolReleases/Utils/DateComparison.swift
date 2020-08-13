//
//  ToolReleaseDateComparison.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 05/06/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import Foundation
import ToolReleasesCore

enum DateComparison {
    /// Checks if the tool was released less than specific amount of time ago.
    /// - Parameters:
    ///   - tool: Provided tool release object.
    ///   - value: Time validation value
    ///   - component: Time component against what the provided value will be validated (day, hour, etc.)
    ///   - since: Compare tool release date to this provided date, by default it provides current date
    /// - Returns: Was the tool released in less than or equal amount of time ago.
    static func isDate(_ date: Date, lessThan value: Int, _ component: Calendar.Component, since: Date = .now) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([component], from: since, to: date)

        guard let componentValue = components.value(for: component) else { return false }

        return abs(componentValue) < value
    }
}
