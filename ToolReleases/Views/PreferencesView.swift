//
//  PreferencesView.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 10/06/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import Sparkle
import SwiftUI

struct PreferencesView: View {
    var body: some View {
        MenuButton("...") {
            Button(action: showAbout) {
                Text("About")
            }
            Button(action: checkForUpdates) {
                Text("Check for Updates")
            }
            Button(action: quit) {
                Text("Quit")
            }
        }
        .menuButtonStyle(BorderlessButtonMenuButtonStyle())
        .frame(width: 16, height: 16)
        .foregroundColor(.primary) // Special case for the enabled "Reduced Transparency" and "Light Mode" (https://github.com/DeveloperMaris/ToolReleases/issues/4)
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
        SUUpdater.shared()?.checkForUpdates(nil)
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
