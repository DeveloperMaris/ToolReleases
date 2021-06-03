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

    private var isUpdateAvailable: Bool { updater.isUpdateAvailable }

    var updateMenuString: String {
        if isUpdateAvailable {
            return "Update is available!"
        } else {
            return "Check for Updates"
        }
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Menu appears as a dropdown box with an icon
            // and a space for the text. If we to hide the
            // text, it still shows an empty space for the
            // text by default, so we need to set a custom
            // frame size, so that the icon would only be
            // visible.
            Menu {
                Button("About", action: showAbout)
                Button(updateMenuString, action: checkForUpdates)
                Button("Quit", action: quit)
            } label: {
                Label("Settings", systemImage: "gear")
                    .labelStyle(IconOnlyLabelStyle())
                    .foregroundColor(Color(.labelColor))
            }
            .menuStyle(BorderlessButtonMenuStyle(showsMenuIndicator: false))
            .frame(width: 14, height: 20)

            BadgeView()
                .opacity(isUpdateAvailable ? 1 : 0)
                .allowsHitTesting(false)
        }
    }

    func quit() {
        NSApp.terminate(nil)
    }

    func showAbout() {
        let view = AboutView()
        let controller = AboutWindowController(aboutView: view)

        if let window = controller.window {
            if let delegate = NSApp.delegate as? AppDelegate {
                delegate.closePopover(sender: nil)
            }
            NSApp.runModal(for: window)
        }
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
