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
    @EnvironmentObject private var toolManager: ToolsManager
    @State private var filter = ToolFilter.all

    private let formatter: DateFormatter = {
        let formatter = DateFormatter()

        formatter.dateStyle = .short
        formatter.timeStyle = .short

        return formatter
    }()

    private var sortedTools: [Tool] {
        toolManager.tools
            .filtered(by: filter)
            .sorted(by: { $0.date > $1.date })
    }

    private var formattedLastRefreshDate: String {
        if let date = toolManager.lastRefresh {
            return formatter.string(from: date)
        }

        return "..."
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

                Button(action: self.fetch) {
                    if toolManager.isRefreshing {
                        ActivityIndicatorView(spinning: true)
                    } else {
                        Image("refresh")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                .disabled(toolManager.isRefreshing)

                PreferencesView()
            }
            .padding([.top, .horizontal])

            Divider()

            // List section
            GeometryReader { geometry in
                List(self.sortedTools) { tool in
                    ToolRow(tool: tool)
                        .frame(width: geometry.size.width - 36, alignment: .leading)
                        .onTapGesture {
                            self.open(tool)
                    }
                }
                .listStyle(SidebarListStyle())
            }

            Divider()

            Text("Last refresh: \(formattedLastRefreshDate)")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom, 10)
        }
        .onAppear {
            self.fetch()
        }
    }

    func open(_ tool: Tool) {
        if let url = tool.url {
            NSWorkspace.shared.open(url)
        }
    }

    func fetch() {
        toolManager.fetch()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
