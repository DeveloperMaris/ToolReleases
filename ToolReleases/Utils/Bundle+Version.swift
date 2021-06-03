//
//  Bundle+Version.swift
//  ToolReleasesCore
//
//  Created by Maris Lagzdins on 10/06/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import Cocoa

extension Bundle {
    var appVersion: String? {
        object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    var buildVersion: String? {
        object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
}
