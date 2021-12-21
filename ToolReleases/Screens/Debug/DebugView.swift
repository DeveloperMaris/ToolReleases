//
//  DebugView.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 21/12/2021.
//  Copyright © 2021 Maris Lagzdins. All rights reserved.
//

import SwiftUI
import ToolReleasesCore

struct DebugView: View {
    @EnvironmentObject private var provider: ToolProvider

    var body: some View {
        VStack {
            Text("Debug Menu")

            Divider()

            Button(action: simulate1NewRelease) {
                Text("Make 1 new release after 3 sec.")
            }

            Button(action: simulate2NewReleases) {
                Text("Make 2 new release after 3 sec.")
            }

            Button(action: simulate3NewReleases) {
                Text("Make 3 new release after 3 sec.")
            }
        }
    }

    private func simulate1NewRelease() {
        simulateNewReleases(1)
    }

    private func simulate2NewReleases() {
        simulateNewReleases(2)
    }

    private func simulate3NewReleases() {
        simulateNewReleases(3)
    }

    private func simulateNewReleases(_ count: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            provider.simulateNewReleases(count)
        }
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
    }
}
