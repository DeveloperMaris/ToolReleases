//
//  ContentView.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 06/03/2020.
//  Copyright © 2020 Developer Maris. All rights reserved.
//

import SwiftUI
import ToolReleasesCore

struct ContentView: View {
    @ObservedObject private var tools = ToolsManager()
    @State private var selection: ToolFilter = .all

    @State var showActivityIndicator = false

    var body: some View {
        VStack {
            // Filter section
            HStack {
                Picker("Select filter", selection: $selection) {
                    ForEach(ToolFilter.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .labelsHidden()
            }
            .padding([.top, .horizontal])

            // List section
            List(self.tools.filteredTools) { tool in
                ReleasedToolRow(tool: tool)
                    .frame(width: 270)
            }
            .listStyle(SidebarListStyle())
            .frame(width: 300, height: 300)
            .onAppear {
                self.tools.fetch()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
