//
//  ReleasedToolRow.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 09/05/2020.
//  Copyright © 2020 Developer Maris. All rights reserved.
//

import Combine
import os.log
import SwiftUI
import ToolReleasesCore

struct ToolRow: View {
    let tool: Tool
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>

    @State private var showPopover = false
    @State private var currentDate = Date()

    private var isRecentRelease: Bool {
        ToolReleaseDateComparison.isTool(tool, releasedLessThan: 3, .day, since: currentDate)
    }

    private var formattedDate: String {
        RelativeDateTimeFormatter().localizedString(for: tool.date, relativeTo: currentDate).capitalized
    }

    var body: some View {
        HStack {
            Text(tool.title)
                .font(.system(size: 12, weight: .medium, design: .default))
                .lineLimit(nil)

            Spacer()

            Text(formattedDate)
                .font(.system(size: 10, weight: isRecentRelease == true ? .bold : .light, design: .default))
                .foregroundColor(isRecentRelease == true ? Color("forestgreen") : .secondary)
                .lineLimit(1)
                .onHover { hover in
                    self.showPopover = hover
                }
                .popover(isPresented: $showPopover) {
                    ToolReleaseDateView(date: self.tool.date)
                }
        }
        .padding([.vertical], 4)
        .onReceive(timer) { date in
            self.currentDate = date
            os_log(.debug, log: .views, "Received timer update, date: %{PUBLIC}@ tool: %{PUBLIC}@", date.debugDescription, self.tool.title)
        }
    }
}

struct ReleasedToolRow_Previews: PreviewProvider {
    static let tool: Tool = {
        let components = DateComponents(second: -30)
        let date = Calendar.current.date(byAdding: components, to: .now)!

        return Tool(
            id: "https://developer.apple.com/news/releases/?id=1234567890a",
            title: "iOS 14.0 (1234567890)",
            date: date,
            url: URL(string: "wwww.apple.com"),
            description: "New release of iOS 14.0"
        )
    }()

    static var previews: some View {
        ToolRow(tool: Self.tool, timer: Timer.publish(every: 1, on: .main, in: .common).autoconnect())
            .frame(width: 300)
    }
}
