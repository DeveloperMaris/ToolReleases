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
    private var subscriptions = Set<AnyCancellable>()

    /// Manages tool information
    private lazy var toolProvider: ToolProvider = {
        let loader = ToolLoader()
        let provider = ToolProvider(loader: loader)
        return provider
    }()

    /// Manages in-app updates
    private lazy var updater: Updater = {
        let updater = Updater()
        updater.startAutomaticBackgroundUpdateChecks()
        return updater
    }()

    private(set) lazy var popover: PopoverController = {
        let popover = PopoverController()
        return popover
    }()

    func start() {
        registerUserDefaults()
        
        if NSApplication.isBetaVersion {
            UserDefaults.standard.set(true, forKey: Storage.isBetaUpdatesEnabled.rawValue)
        }

        let vc = makeInitialViewController()

        popover.configureStatusBarView()
        popover.setContentViewController(vc)

        toolProvider.enableAutomaticUpdates()
        subscribeForToolUpdates()
        subscribeForPopoverAppearNotification()
    }
}

private extension Bootstrap {
    func makeInitialViewController() -> NSViewController {
        let view = ContentView()
            .environmentObject(updater)
            .environmentObject(toolProvider)

        return NSHostingController(rootView: view)
    }

    func subscribeForToolUpdates() {
        toolProvider.newToolsPublisher
            .sink { [weak self] tools in
                guard let self = self else {
                    return
                }

                guard self.popover.isPopoverShown == false else {
                    return
                }

                if tools.isEmpty == false {
                    self.popover.showBadge()
                    self.localNotificationProvider.addNotification(about: tools) { success in
                        if success {
                            Self.logger.debug("Notification added")
                        } else {
                            Self.logger.debug("Notification adding failed")
                        }
                    }
                }
            }
            .store(in: &subscriptions)
    }

    func subscribeForPopoverAppearNotification() {
        notificationCenter.addObserver(
            self,
            selector: #selector(removeLocalNotifications),
            name: .windowWillAppear,
            object: nil
        )
    }

    @objc
    func removeLocalNotifications() {
        localNotificationProvider.removeAllNotifications()
    }

    func registerUserDefaults() {
        UserDefaults.standard.register(defaults: [
            Storage.isBetaUpdatesEnabled.rawValue: false
        ])
    }
}
