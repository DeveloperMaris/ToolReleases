//
//  PreferencesView.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 10/06/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import Cocoa
import SwiftUI

struct PreferencesView: View {
    var body: some View {
        MenuButton("...") {
            Button(action: showAbout) {
                Text("About")
            }
            Button(action: quit) {
                Text("Quit")
            }
        }
        .menuButtonStyle(BorderlessButtonMenuButtonStyle())
        .frame(width: 16, height: 16)
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
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
