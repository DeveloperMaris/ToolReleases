//
//  Logger+CustomInitializer.swift
//  ToolReleasesCore
//
//  Created by Maris Lagzdins on 19/12/2021.
//  Copyright © 2021 Maris Lagzdins. All rights reserved.
//

import Foundation
import os.log

extension Logger {
    init(category: String) {
        // swiftlint:disable:next force_unwrapping
        self.init(subsystem: Bundle.main.bundleIdentifier!, category: "ToolReleases.Core.\(category)")
    }
}
