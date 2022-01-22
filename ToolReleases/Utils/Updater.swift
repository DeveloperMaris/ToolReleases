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

final class Updater: NSObject, ObservableObject {
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
    private var updaterController: SPUStandardUpdaterController!
    private var automaticUpdateCheckTimer: Timer?

    @Published public private(set) var isUpdateAvailable = false

    override init() {
        super.init()
        self.updaterController = SPUStandardUpdaterController(
            startingUpdater: true,
            updaterDelegate: self,
            userDriverDelegate: nil
        )
    }

    func checkForUpdates() {
        Self.logger.debug("Explicitly check for an app update")
        updaterController.checkForUpdates(nil)
    }

    func silentlyCheckForUpdates() {
        Self.logger.debug("Silently check for an app update")
        updaterController.updater.checkForUpdateInformation()
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

extension Updater: SPUUpdaterDelegate {
    func updater(_ updater: SPUUpdater, didFindValidUpdate item: SUAppcastItem) {
        Self.logger.debug(
            """
            New version available, /
            version /
            \(item.displayVersionString ?? "n/a", privacy: .public)./
            \(item.versionString, privacy: .public)
            """
        )
        isUpdateAvailable = true
    }

    func updaterDidNotFindUpdate(_ updater: SPUUpdater) {
        Self.logger.debug("New version is not available.")
        isUpdateAvailable = false
    }
}
