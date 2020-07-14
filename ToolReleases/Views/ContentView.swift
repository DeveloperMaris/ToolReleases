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
        VStack {
            // Filter section
            VStack {
                HStack {
                    Picker("Select filter", selection: $typeFilter) {
                        ForEach(ToolFilter.allCases, id: \.self) {
                            Text($0.description)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .labelsHidden()

                    SearchButton {
                        withAnimation {
                            self.showKeywordFilter.toggle()
                        }
                    }

                    PreferencesView()
                }

                if showKeywordFilter {
                    TextField("Xcode; macOS beta", text: $keywordFilterText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .transition(AnyTransition.offset(x: 0, y: -30).combined(with: .opacity))
                }
            }
            .padding([.top, .horizontal])

            Divider()

            // List section
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
                GeometryReader { geometry in
                    List(self.sortedTools) { tool in
                        ToolRow(tool: tool, timer: self.relativeDateTimeTimer)
                            .frame(width: geometry.size.width - 36, alignment: .leading)
                            .onTapGesture {
                                self.open(tool)
                        }
                    }
                    .listStyle(SidebarListStyle())
                }
            }

            Divider()

            LastRefreshView(isRefreshing: toolManager.isRefreshing, lastRefreshDate: toolManager.lastRefresh, handler: fetch)
                .padding(.bottom, 10)
                .padding(.horizontal)
        }
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
