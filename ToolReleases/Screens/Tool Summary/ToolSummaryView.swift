//
//  ToolSummaryView.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 28/05/2021.
//  Copyright © 2021 Maris Lagzdins. All rights reserved.
//

import Combine
import os.log
import SwiftUI
import ToolReleasesCore

struct ToolSummaryView: View {
    @StateObject private var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                HStack(spacing: 16) {
                    Picker("Select filter", selection: $viewModel.filter) {
                        ForEach(ViewModel.Filter.allCases, id: \.self) {
                            Text($0.description)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .labelsHidden()

                    SearchButton {
                        withAnimation {
                            viewModel.isKeywordFilterEnabled.toggle()
                        }
                    }

                    PreferencesView()
                }

                if viewModel.isKeywordFilterEnabled {
                    TextField("iOS; macOS beta", text: $viewModel.keywords)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .transition(.opacity)
                }
            }
            .padding()

            Divider()

            Group {
                if viewModel.tools.isEmpty {
                    Text("No releases available")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.tools) { tool in
                            ToolRowView(tool: tool, timer: viewModel.timer)
                                .onTapGesture {
                                    open(tool)
                                }
                        }
                    }
                }
            }
            .background(Color(.textBackgroundColor))

            Divider()

            LastRefreshView(
                isRefreshing: viewModel.isRefreshing,
                lastRefreshDate: viewModel.lastRefresh,
                handler: fetch
            )
            .padding()
        }
        .background(Color(.windowBackgroundColor))
        .onAppear {
            os_log(.debug, log: .views, "Initial fetch")
            fetch()
        }
    }

    init(manager: ToolManager = .current) {
        let viewModel = ViewModel(manager: manager)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}

// MARK: - Private methods
private extension ToolSummaryView {
    func open(_ tool: Tool) {
        if let url = tool.url {
            NSWorkspace.shared.open(url)
        }
    }

    func fetch() {
        viewModel.fetch()
    }
}

struct ToolSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ToolSummaryView()
    }
}
