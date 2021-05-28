//
//  ContentView.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 06/03/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import Combine
import os.log
import SwiftUI
import ToolReleasesCore

struct ContentView: View {
    @EnvironmentObject private var toolManager: ToolManager
    @State private var typeFilter = ToolFilter.all
    @State private var relativeDateTimeTimer = Timer.makeRelativeDateTimeTimer().autoconnect()
    @State private var showKeywordFilter: Bool = false
    @State private var keywordFilterText: String = ""

    private var sortedTools: [Tool] {
        let keywordGroups = Search.transformKeywords(keywordFilterText)

        return toolManager.tools
            .filtered(by: typeFilter)
            .filter { showKeywordFilter && keywordGroups.isEmpty == false ? $0.title.contains(keywordGroups) : true }
            .sorted(by: { $0.date > $1.date })
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                HStack(spacing: 16) {
                    Picker("Select filter", selection: $typeFilter) {
                        ForEach(ToolFilter.allCases, id: \.self) {
                            Text($0.description)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .labelsHidden()

                    SearchButton {
                        withAnimation {
                            showKeywordFilter.toggle()
                        }
                    }

                    PreferencesView()
                }

                if showKeywordFilter {
                    TextField("iOS; macOS beta", text: $keywordFilterText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .transition(.opacity)
                }
            }
            .padding()

            Divider()

            if toolManager.tools.isEmpty {
                // No tools are available
                Text("No information about the released tools")
                    .frame(maxHeight: .infinity)
                    .padding()
            } else if sortedTools.isEmpty {
                // No tools with specific filter are available
                Text("No releases available")
                    .frame(maxHeight: .infinity)
                    .padding()
            } else {
                List {
                    ForEach(sortedTools) { tool in
                        ToolRow(tool: tool, timer: relativeDateTimeTimer)
                            .onTapGesture {
                                open(tool)
                            }
                    }
                }
            }

            Divider()

            LastRefreshView(isRefreshing: toolManager.isRefreshing, lastRefreshDate: toolManager.lastRefresh, handler: fetch)
                .padding()
        }
        .background(Color(.windowBackgroundColor))
        .onAppear {
            os_log(.debug, log: .views, "Initial fetch")
            self.fetch()
        }
        .onReceive(NotificationCenter.default.publisher(for: .popoverWillAppear)) { _ in
            os_log(.debug, log: .views, "Popover will appear event received")
            self.startTimer()
        }
        .onReceive(NotificationCenter.default.publisher(for: .popoverDidDisappear)) { _ in
            os_log(.debug, log: .views, "Popover did disappear event received")
            self.stopTimer()
        }
    }

    private func open(_ tool: Tool) {
        if let url = tool.url {
            NSWorkspace.shared.open(url)
        }
    }

    private func fetch() {
        toolManager.fetch()
    }

    private func startTimer() {
        stopTimer()
        self.relativeDateTimeTimer = Timer.makeRelativeDateTimeTimer().autoconnect()
    }

    private func stopTimer() {
        self.relativeDateTimeTimer.upstream.connect().cancel()
    }
}

fileprivate extension Timer {
    static func makeRelativeDateTimeTimer() -> Timer.TimerPublisher {
        Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
