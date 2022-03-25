//
//  Bootstrap.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 19/12/2021.
//  Copyright © 2021 Maris Lagzdins. All rights reserved.
//

import Cocoa
import Combine
import os.log
import SwiftUI
import ToolReleasesCore
import UserNotifications

class Bootstrap {
    static private let logger = Logger(category: "Bootstrap")

    private let notificationCenter: NotificationCenter = .default
    private let localNotificationProvider = LocalNotificationProvider()

    private var cancellables = Set<AnyCancellable>()

    private lazy var preferences = Preferences()

    /// Manages tool information
    private lazy var toolProvider: ToolProvider = {
        let loader = ToolLoader()
        let provider = ToolProvider(loader: loader)
        return provider
    }()

    /// Manages in-app updates
    private lazy var updater: Updater = {
        let updater = Updater(preferences: preferences)
        updater.startBackgroundChecks()
        return updater
    }()

    private(set) lazy var popover: PopoverController = {
        let popover = PopoverController()
        return popover
    }()

    func start() {
        let vc = makeInitialViewController()

        popover.configureStatusBarView()
        popover.setContentViewController(vc)

        localNotificationProvider.requestNotificationAuthorizationIfNecessary()

        toolProvider.enableAutomaticUpdates()
        subscribeForToolUpdates()
        subscribeForPopoverAppearNotification()

        // To make the first app launch faster, just pre-fetch all the available tool releases.
        toolProvider.fetch()
    }
}

private extension Bootstrap {
    func makeInitialViewController() -> NSViewController {
        let view = ContentView()
            .environmentObject(updater)
            .environmentObject(preferences)
            .environmentObject(toolProvider)

        return NSHostingController(rootView: view)
    }

    func subscribeForToolUpdates() {
        toolProvider.newToolsPublisher
            .filter { $0.isEmpty == false }
            .sink { [weak self] tools in
                guard let self = self else {
                    return
                }

                guard self.popover.isPopoverShown == false else {
                    return
                }

                self.popover.showBadge()

                if self.preferences.isNotificationsEnabled {
                    self.localNotificationProvider.addNotification(about: tools) { success in
                        if success {
                            Self.logger.debug("Notification added")
                        } else {
                            Self.logger.debug("Notification adding failed")
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }

    func subscribeForPopoverAppearNotification() {
        notificationCenter
            .publisher(for: .windowWillAppear)
            .sink { [weak self] _ in
                self?.removeNotifications()
            }
            .store(in: &cancellables)
    }

    func removeNotifications() {
        popover.removeBadge()
        localNotificationProvider.removeAllNotifications()
    }
}
