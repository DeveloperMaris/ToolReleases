//
//  OSLog.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 06/03/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import Foundation
import os.log

extension Logger {
    init(category: String) {
        // swiftlint:disable:next force_unwrapping
        self.init(subsystem: Bundle.main.bundleIdentifier!, category: "ToolReleases.\(category)")
    }
}
