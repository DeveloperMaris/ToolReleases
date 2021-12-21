//
//  Calendar+DateComparison.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 05/06/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import Foundation

extension Calendar {
    /// Compares start and end date component value and determines if it is smaller that the provided value.
    /// - Parameters:
    ///   - component: Which component to compare.
    ///   - start: The starting date.
    ///   - end: The ending date.
    ///   - value: Component value to compare against.
    /// - Returns: Is the date component value less than the provided value.
    func isDateComponent(
        _ component: Calendar.Component,
        from start: Date,
        to end: Date,
        lessThan value: Int
    ) -> Bool {
        let components = dateComponents([component], from: start, to: end)

        guard let componentValue = components.value(for: component) else {
            return false
        }

        return abs(componentValue) < value
    }
}
