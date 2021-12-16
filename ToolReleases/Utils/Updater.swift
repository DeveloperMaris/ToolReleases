//
//  Updater.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 20/07/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import Combine
import Foundation
import os.log
import Sparkle

class Updater: NSObject, ObservableObject {
    static private let automaticUpdateCheckTimeInterval: TimeInterval = {
        let interval: TimeInterval
        #if DEBUG
            interval = 10 // 10 seconds
        #else
            interval = 3_600 // 1 hour
        #endif
        os_log(.debug, log: .updater, "Update check interval set to %{public}f", interval)
        return interval
    }()
    private let manager: SUUpdater
    private var automaticUpdateCheckTimer: Timer?

    @Published public private(set) var isUpdateAvailable = false

    init(manager: SUUpdater = .shared()) {
        self.manager = manager
        super.init()

        self.manager.delegate = self
    }

    func checkForUpdates() {
        os_log(.debug, log: .updater, "Explicitly check for an app update")
        manager.checkForUpdates(nil)
    }

    func silentlyCheckForUpdates() {
        os_log(.debug, log: .updater, "Silently check for an app update")
        manager.checkForUpdateInformation()
    }

    func startAutomaticBackgroundUpdateChecks() {
        os_log(.debug, log: .updater, "%{public}@", #function)
        automaticUpdateCheckTimer?.invalidate()
        automaticUpdateCheckTimer = Timer.scheduledTimer(
            withTimeInterval: Self.automaticUpdateCheckTimeInterval,
            repeats: true
        ) { [weak self] _ in
            self?.silentlyCheckForUpdates()
        }
    }

    func stopAutomaticBackgroundUpdateChecks() {
        os_log(.debug, log: .updater, "%{public}@", #function)
        automaticUpdateCheckTimer?.invalidate()
        automaticUpdateCheckTimer = nil
    }
}

extension Updater: SUUpdaterDelegate {
    func updater(_ updater: SUUpdater, didFindValidUpdate item: SUAppcastItem) {
        os_log(
            .debug,
            log: .updater,
            "Update found, version: %{public}@.%{public}@",
            item.displayVersionString,
            item.versionString
        )
        isUpdateAvailable = true
    }

    func updaterDidNotFindUpdate(_ updater: SUUpdater) {
        os_log(.debug, log: .updater, "Update not found")
        isUpdateAvailable = false
    }
}
