//
//  NSApplication+Extension.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 26/01/2022.
//  Copyright © 2022 Maris Lagzdins. All rights reserved.
//

import Cocoa

extension NSApplication {
    static var isBetaVersion: Bool { Bundle.main.appVersion?.contains("beta") ?? false }
}
