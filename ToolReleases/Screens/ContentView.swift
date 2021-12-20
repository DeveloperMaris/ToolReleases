//
//  ContentView.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 06/03/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import SwiftUI
import ToolReleasesCore

struct ContentView: View {
    @EnvironmentObject var provider: ToolProvider

    var body: some View {
        ToolSummaryView(provider: provider)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
