//
//  OSLog.swift
//  ToolReleasesCore
//
//  Created by Maris Lagzdins on 04/06/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import Foundation
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let toolManager = OSLog(subsystem: subsystem, category: "ToolManager")
}
