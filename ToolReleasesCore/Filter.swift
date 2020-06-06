//
//  Filter.swift
//  ToolReleasesCore
//
//  Created by Maris Lagzdins on 19/05/2020.
//  Copyright © 2020 Developer Maris. All rights reserved.
//

import Foundation

public enum ToolFilter: CaseIterable, CustomStringConvertible {
    case all
    case beta
    case release

    public var description: String {
        switch self {
        case .all:
            return "All"
        case .beta:
            return "Beta"
        case .release:
            return "Released"
        }
    }
}

extension Sequence where Element == Tool {
    public func filtered(by filter: ToolFilter) -> [Element] {
        switch filter {
        case .all:
            return self as! [Element]
        case .beta:
            return self.filter { $0.isBeta || $0.isGMSeed }
        case .release:
            return self.filter { $0.isRelease }
        }
    }
}
