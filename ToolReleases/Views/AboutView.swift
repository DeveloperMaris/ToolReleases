//
//  AboutView.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 30/06/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    private let appVersion = NSApplication.appVersion ?? "N/A"
    private let buildVersion = NSApplication.buildVersion ?? "N/A"
    
    var body: some View {
        VStack(spacing: 10) {
            VStack(spacing: 5) {
                Image("about_icon")
                    .resizable()
                    .frame(width: 64, height: 64)
                Text("Tool Releases")
                    .font(.headline)

                Text("v\(appVersion), build \(buildVersion)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("Copyright © 2020 Maris Lagzdins. All rights reserved.")
                    .font(.caption)
                    .italic()
            }

            Divider()

            VStack(spacing: 2) {
                Text("Application uses Apple Inc. publicly available RSS feed to collect and display information from it.")
                Text("Collected content isn't modified in any way.")
                Text("Collected content copyrights belongs to Apple Inc.")
            }
        }
        .padding()
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
