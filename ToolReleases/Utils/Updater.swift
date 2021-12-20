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
    static private let logger = Logger(category: "Updater")

    static private let automaticUpdateCheckTimeInterval: TimeInterval = {
        let interval: TimeInterval
        #if DEBUG
            interval = 10 // 10 seconds
        #else
            interval = 3_600 // 1 hour
        #endif
        logger.debug("Update check interval set to \(interval, privacy: .public)")
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
        Self.logger.debug("Explicitly check for an app update")
        manager.checkForUpdates(nil)
    }

    func silentlyCheckForUpdates() {
        Self.logger.debug("Silently check for an app update")
        manager.checkForUpdateInformation()
    }

    func startAutomaticBackgroundUpdateChecks() {
        Self.logger.debug("Start automatic background update checks")
        automaticUpdateCheckTimer?.invalidate()
        automaticUpdateCheckTimer = Timer.scheduledTimer(
            withTimeInterval: Self.automaticUpdateCheckTimeInterval,
            repeats: true
        ) { [weak self] _ in
            self?.silentlyCheckForUpdates()
        }
    }

    func stopAutomaticBackgroundUpdateChecks() {
        Self.logger.debug("Stop automatic background update checks")
        automaticUpdateCheckTimer?.invalidate()
        automaticUpdateCheckTimer = nil
    }
}

extension Updater: SUUpdaterDelegate {
    func updater(_ updater: SUUpdater, didFindValidUpdate item: SUAppcastItem) {
        Self.logger.debug(
            "Update found, version \(item.displayVersionString, privacy: .public).\(item.versionString, privacy: .public)"
        )
        isUpdateAvailable = true
    }

    func updaterDidNotFindUpdate(_ updater: SUUpdater) {
        Self.logger.debug("Update not found")
        isUpdateAvailable = false
    }
}
