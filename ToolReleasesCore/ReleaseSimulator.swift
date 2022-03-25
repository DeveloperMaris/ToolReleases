//
//  FakeUpdateController.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 21/12/2021.
//  Copyright © 2021 Maris Lagzdins. All rights reserved.
//

#if DEBUG

import Foundation

class ReleaseSimulator {
    enum ToolName: String, CaseIterable {
        case iOS, iPadOS, macOS, tvOS, watchOS, Xcode
    }

    func makeRandomRelease() -> Tool {
        let tool = ToolName.allCases.randomElement()!
        let isBeta = Bool.random()
        let version = String.random(6)

        let title: String

        if isBeta {
            title = "\(tool) 00.\(Int.random(in: 1...99)).\(Int.random(in: 1...99)) beta (\(version))"
        } else {
            title = "\(tool) 00.\(Int.random(in: 1...99)).\(Int.random(in: 1...99)) (\(version))"
        }

        return Tool(
            id: title,
            title: title,
            date: Date(),
            url: URL(string: "https://www.example.com"),
            description: "Lorem Ipsum."
        )
    }
}

fileprivate extension String {
    static func random(_ length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var s = ""
        for _ in 0 ..< length {
            s.append(letters.randomElement()!)
        }
        return s
    }
}

#endif
