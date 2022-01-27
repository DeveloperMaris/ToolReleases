//
//  Preferences.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 27/01/2022.
//  Copyright © 2022 Maris Lagzdins. All rights reserved.
//

import Foundation

final class Preferences: ObservableObject {
    private enum Key: String {
        case isBetaUpdatesEnabled
    }

    private let defaults: UserDefaults

    let appVersion: String
    let buildVersion: String
    let isBetaVersion: Bool
    
    @Published var isBetaUpdatesEnabled: Bool {
        didSet { defaults.set(isBetaUpdatesEnabled, forKey: Key.isBetaUpdatesEnabled.rawValue) }
    }

    init(defaults: UserDefaults = .standard) {
        // Register defaults
        UserDefaults.standard.register(defaults: [
            Key.isBetaUpdatesEnabled.rawValue: false
        ])

        self.defaults = defaults

        appVersion = Bundle.main.appVersion!
        buildVersion = Bundle.main.buildVersion!

        isBetaVersion = appVersion.contains("beta")
        isBetaUpdatesEnabled = defaults.bool(forKey: Key.isBetaUpdatesEnabled.rawValue)

        if isBetaVersion {
            isBetaUpdatesEnabled = true
        }
    }
}
