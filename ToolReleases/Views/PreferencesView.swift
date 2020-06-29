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
    private let appVersion = NSApplication.appVersion ?? "N/A"

    var body: some View {
        MenuButton("...") {
            Button(action: quit) {
                Text("Quit")
            }

            VStack { Divider() }

            Text("v\(appVersion)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .menuButtonStyle(BorderlessButtonMenuButtonStyle())
        .frame(width: 16, height: 16)
    }

    func quit() {
        NSApp.terminate(nil)
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
