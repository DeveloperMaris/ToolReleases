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

    var showBadge: Bool {
        updater.isUpdateAvailable
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            BadgeView()
                .offset(x: 5, y: -7)
                .opacity(showBadge ? 1 : 0)

            MenuButton("...") {
                Button(action: showAbout) {
                    Text("About")
                }
                Button(action: checkForUpdates) {
                    ZStack(alignment: .bottomTrailing) {
                        Text("Check for Updates")

                        BadgeView()
                            .offset(x: 6, y: -6)
                            .opacity(updater.isUpdateAvailable ? 1 : 0)
                    }
                }
                Button(action: quit) {
                    Text("Quit")
                }
            }
            .menuButtonStyle(BorderlessButtonMenuButtonStyle())
            .frame(width: 16, height: 16)
            .foregroundColor(.primary) // Special case for the enabled "Reduced Transparency" and "Light Mode" (https://github.com/DeveloperMaris/ToolReleases/issues/4)
            .onReceive(NotificationCenter.default.publisher(for: .popoverWillAppear)) { _ in
                os_log(.debug, log: .views, "Popover will appear event received")
            }
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
