//
//  OSLog.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 06/03/2020.
//  Copyright © 2020 Developer Maris. All rights reserved.
//

import Foundation
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let appDelegate = OSLog(subsystem: subsystem, category: "AppDelegate")
    static let views = OSLog(subsystem: subsystem, category: "Views")
}
