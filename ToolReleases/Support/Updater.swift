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

    private let preferences: Preferences
    private let betaChannels: Set<String>

    /// A time interval for the automatic app update checks.
    private let automaticUpdateInterval: TimeInterval

    private var updateCancellable: AnyCancellable?
    private var updaterController: SPUStandardUpdaterController!

    @Published public private(set) var isUpdateAvailable = false

    init(preferences: Preferences) {
        self.preferences = preferences
        self.betaChannels = Set(["beta"])
        
        #if DEBUG
        self.automaticUpdateInterval = 10 // 10 seconds
        #else
        self.automaticUpdateInterval = 3_600 // 1 hour
        #endif

        super.init()

        self.updaterController = SPUStandardUpdaterController(
            startingUpdater: true,
            updaterDelegate: self,
            userDriverDelegate: nil
        )

        Self.logger.debug("Update check interval set to \(self.automaticUpdateInterval, privacy: .public)")
    }

    func checkForUpdates() {
        Self.logger.debug("Explicitly check for an app update")
        updaterController.checkForUpdates(nil)
    }

    func checkForUpdatesSilently() {
        Self.logger.debug("Silently check for an app update")
        updaterController.updater.checkForUpdateInformation()
    }

    func startBackgroundChecks() {
        Self.logger.debug("Start automatic background update checks")
        updateCancellable = Timer
            .publish(every: automaticUpdateInterval, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkForUpdatesSilently()
            }
    }

    func stopBackgroundChecks() {
        Self.logger.debug("Stop automatic background update checks")
        updateCancellable = nil
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

    func allowedChannels(for updater: SPUUpdater) -> Set<String> {
        return preferences.isBetaUpdatesEnabled ? betaChannels : []
    }
}
