//
//  Notification+Extension.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 26/06/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let windowWillAppear = Notification.Name(rawValue: "ToolRelease.Notification.WindowWillAppear")
    static let windowDidDisappear = Notification.Name(rawValue: "ToolRelease.Notification.WindowDidDisappear")
}
