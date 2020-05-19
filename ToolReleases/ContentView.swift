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
    @ObservedObject private var toolManager = ToolsManager()
    @State private var filter: ToolFilter = .all

    private var sortedTools: [Tool] {
        toolManager.tools
            .filtered(by: filter)
            .sorted(by: { $0.date > $1.date })
    }

    var body: some View {
        VStack {
            // Filter section
            HStack {
                Picker("Select filter", selection: $filter) {
                    ForEach(ToolFilter.allCases, id: \.self) {
                        Text($0.description)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .labelsHidden()
            }
            .padding([.top, .horizontal])

            // List section
            List(sortedTools) { tool in
                ReleasedToolRow(tool: tool)
                    .frame(width: 270)
            }
            .listStyle(SidebarListStyle())
            .frame(width: 300, height: 300)
            .onAppear {
                self.toolManager.fetch()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
