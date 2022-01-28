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
            Menu {
                if preferences.isBetaVersion {
                    Text("Beta version")
                    Divider()
                }

                Button("About", action: showAbout)
                Button("Notifications", action: showNotificationPreferences)
                Button(updateMenuString, action: checkForUpdates)
                Divider()
                Button("Quit", action: quit)

                if preferences.isBetaUpdatesEnabled {
                    Divider()
                    Text("Beta updates enabled")
                    Button("Disable") {
                        preferences.isBetaUpdatesEnabled = false
                    }
                }
            } label: {
                Label("Settings", systemImage: "gear")
                    .labelStyle(.iconOnly)
                    .foregroundColor(Color(.labelColor))
            }
            .menuStyle(.borderlessButton)
            .frame(width: 14, height: 20)

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

        if let delegate = NSApp.delegate as? AppDelegate {
            delegate.closePopover()
        }

        controller.showWindow(nil)
    }

    func showNotificationPreferences() {
        let view = NotificationPreferencesView(preferences: preferences)
        let controller = NotificationPreferencesWindowController(view: view)

        if let delegate = NSApp.delegate as? AppDelegate {
            delegate.closePopover()
        }

        controller.showWindow(nil)
    }

    func checkForUpdates() {
        updater.checkForUpdates()
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
