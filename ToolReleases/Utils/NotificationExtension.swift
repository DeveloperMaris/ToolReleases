//
//  NotificationExtension.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 26/06/2020.
//  Copyright © 2020 Developer Maris. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let popoverWillAppear = Notification.Name(rawValue: "ToolRelease.Notification.PopoverWillAppear")
    static let popoverDidDisappear = Notification.Name(rawValue: "ToolRelease.Notification.PopoverDidDisappear")
}
