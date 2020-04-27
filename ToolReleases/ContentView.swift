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
    @ObservedObject private var feed = ToolsManager()
    @State private var selectedFilter: ToolFilter = .all {
        didSet {
            feed.filter(selectedFilter)
        }
    }

    var body: some View {
        VStack {
            HStack {
                Picker("Select filter", selection: $selectedFilter) {
                    ForEach(ToolFilter.allCases, id: \.self) {
                        Text($0.description)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .labelsHidden()
            }
            .padding([.top, .horizontal])

            List(feed.filteredTools) { tool in
                VStack(alignment: .leading) {
                    Text(tool.description.trimmingCharacters(in: .whitespacesAndNewlines))
                        .font(.system(size: 12, weight: .medium, design: .default))

                    Text(tool.formattedDate)
                        .font(.system(size: 10, weight: .thin, design: .default))
                }
                .padding(.bottom, 5)
            }
            .listStyle(SidebarListStyle())
            .onAppear {
                self.feed.fetch()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
