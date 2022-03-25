//
//  PreferencesView.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 10/06/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import os.log
import SwiftUI

struct PreferencesView: View {
    @EnvironmentObject private var updater: Updater
    @EnvironmentObject private var preferences: Preferences

    @ViewBuilder
    private var menu: some View {
        let menu = Menu {
            Button("About", action: showAbout)
            Button("Notifications", action: showNotificationPreferences)
            Button(updateMenuString, action: checkForUpdates)
            Divider()
            Button("Quit", action: quit)

            if preferences.isBetaVersion || preferences.isBetaUpdatesEnabled {
                Divider()
            }

            if preferences.isBetaVersion {
                Text("Beta version \(preferences.appVersion)")
            }

            if preferences.isBetaUpdatesEnabled {
                Button("Disable Beta updates") {
                    preferences.isBetaUpdatesEnabled = false
                }
            }
        } label: {
            Label("Settings", systemImage: "gear")
                .imageScale(.medium)
                .labelStyle(.iconOnly)
        }

        if #available(macOS 12, *) {
            menu.menuIndicator(.hidden)
        } else {
            menu
        }
    }

    var updateMenuString: String {
        if updater.isUpdateAvailable {
            return "Update is available!"
        } else {
            return "Check for Updates"
        }
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Menu appears as a dropdown box with an icon
            // and a space for the text. If we want to hide the
            // text, it still shows an empty space for the
            // text by default, so we need to set a custom
            // frame size, so that the icon would only be
            // visible.
            menu
                .frame(width: 20, height: 20)
                .menuStyle(.borderlessButton)
                .foregroundColor(Color(.labelColor))

            BadgeView()
                .opacity(updater.isUpdateAvailable ? 1 : 0)
                .allowsHitTesting(false)
        }
    }

    func quit() {
        NSApp.terminate(nil)
    }

    func showAbout() {
        let view = AboutView(preferences: preferences)
        let controller = AboutWindowController(aboutView: view)

        closeMainWindow()
        controller.showWindow(nil)
    }

    func showNotificationPreferences() {
        let view = NotificationPreferencesView(preferences: preferences)
        let controller = NotificationPreferencesWindowController(view: view)

        closeMainWindow()
        controller.showWindow(nil)
    }

    func checkForUpdates() {
        closeMainWindow()
        updater.checkForUpdates()
    }

    private func closeMainWindow() {
        if let delegate = NSApp.delegate as? AppDelegate {
            delegate.closePopover()
        }
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
