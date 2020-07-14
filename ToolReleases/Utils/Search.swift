//
//  Search.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 10/07/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import Foundation

enum Search {
    struct Group: Equatable {
        struct Keyword: Equatable {
            var string: String

            init(_ string: String) {
                self.string = string
            }
        }
        
        var keywords: [Keyword]

        init(_ keywords: [Keyword]) {
            self.keywords = keywords
        }
    }

    /// Transforms keyword string into an Array containing multiple groups of search phrases.
    ///
    /// Each group can contain one or more search phrases.
    /// Groups are separated by the ";" symbol and each group search phrases are separated by a whitespace.
    ///
    /// Examples:
    ///
    /// Provided string : *"iOS Beta; Xcode"*
    ///
    /// Group1: *["iOS", "Beta"]*
    ///
    /// Group2: *["Xcode"]*
    ///
    /// - Parameter keywords: Multiple search keywords which are translated into groups of search phrases
    /// - Returns: 2 dimensional array where 1st level represents a collection of groups and 2nd level represents search phrases for a specific  group
    static func transformKeywords(_ keywords: String) -> [Group] {
        let keywords = keywords.trimmingCharacters(in: .whitespacesAndNewlines)
        guard keywords.isEmpty == false else {
            return []
        }

        // Keywords can contain string like: "iOS Beta; Xcode 11; "
        // Create an array: ["iOS Beta", "Xcode 11", " "]
        let array = keywords.split(separator: ";")

        guard array.isEmpty == false else {
            return []
        }

        return array
            // Create subarrays: [[Keyword("iOS"), Keyword("Beta")], [Keyword("Xcode"), Keyword("11")], []]
            .map { $0.split(separator: " ").map { Group.Keyword(String($0)) } }
            // Remove empty arrays: [[Keyword("iOS"), Keyword("Beta")], [Keyword("Xcode"), Keyword("11")]]
            .filter { $0.isEmpty == false }
            // Maps to: [Group([Keyword("iOS"), Keyword("Beta")]), Group([Keyword("Xcode"), Keyword("11")])]
            .map(Group.init)
    }
}

extension String {
    func contains(_ groups: [Search.Group]) -> Bool {
        groups.contains { self.contains($0.keywords) }
    }

    func contains(_ keywords: [Search.Group.Keyword]) -> Bool {
        let string = self.lowercased()
        return keywords
            .map { $0.string.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) }
            .allSatisfy(string.contains)
    }
}
