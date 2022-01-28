//
//  NotificationPreferencesView.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 28/01/2022.
//  Copyright © 2022 Maris Lagzdins. All rights reserved.
//

import SwiftUI

struct NotificationPreferencesView: View {
    @ObservedObject private var preferences: Preferences

    init(preferences: Preferences) {
        _preferences = ObservedObject(wrappedValue: preferences)
    }
    
    var body: some View {
        Form {
            Section {
                Toggle("New tool notifications", isOn: $preferences.isNotificationsEnabled)
                    .toggleStyle(.switch)
            } footer: {
                Text("Allows the app to show a notification each time a new tool releases are detected.")
                    .font(.footnote)
                    .foregroundColor(Color(.secondaryLabelColor))
            }
        }
        .padding()
        .frame(width: 330, height: 100)
    }
}

struct NotificationPreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationPreferencesView(preferences: Preferences())
    }
}
