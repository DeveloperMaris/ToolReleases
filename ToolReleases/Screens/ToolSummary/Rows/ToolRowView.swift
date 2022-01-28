//
//  ReleasedToolRow.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 09/05/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import Combine
import os.log
import SwiftUI
import ToolReleasesCore

struct ToolRowView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        HStack {
            Text(viewModel.tool.title)
                .font(.system(size: 12, weight: .medium, design: .default))
                .lineLimit(nil)

            Spacer()

            Text(viewModel.relativeDate)
                .font(.system(size: 10, weight: viewModel.isRecentRelease == true ? .bold : .light, design: .default))
                .foregroundColor(viewModel.isRecentRelease == true ? Color("forestgreen") : .secondary)
                .lineLimit(1)
                .help(viewModel.fullDate)
        }
        .padding([.vertical], 4)
        .onAppear {
            viewModel.subscribeForTimerUpdates()
        }
        .onReceive(NotificationCenter.default.publisher(for: .windowWillAppear)) { _ in
            viewModel.subscribeForTimerUpdates()
        }
        .onReceive(NotificationCenter.default.publisher(for: .windowDidDisappear)) { _ in
            viewModel.unsubscribeFromTimerUpdates()
        }
    }

    init(tool: Tool, timer: Publishers.Autoconnect<Timer.TimerPublisher>) {
        _viewModel = StateObject(wrappedValue: ViewModel(tool: tool, timer: timer))
    }
}

struct ReleasedToolRow_Previews: PreviewProvider {
    static var previews: some View {
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        return ToolRowView(tool: .example, timer: timer)
            .frame(width: 300)
    }
}
