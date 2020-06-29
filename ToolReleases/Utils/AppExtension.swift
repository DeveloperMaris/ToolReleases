//
//  AppInformation.swift
//  ToolReleasesCore
//
//  Created by Maris Lagzdins on 10/06/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import Cocoa

extension NSApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    static var buildVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
}
