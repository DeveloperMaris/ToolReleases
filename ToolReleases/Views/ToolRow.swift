//
//  ReleasedToolRow.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 09/05/2020.
//  Copyright © 2020 Developer Maris. All rights reserved.
//

import SwiftUI
import ToolReleasesCore

struct ToolRow: View {
    @State private var showPopover = false

    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()

        formatter.dateStyle = .full
        formatter.timeStyle = .short

        return formatter
    }()

    private let recentReleaseValue = 3
    private let recentReleaseUnit = Calendar.Component.day

    let tool: Tool

    var body: some View {
        let isRecentRelease = ToolReleaseDateComparison.isTool(tool, releasedLessThan: recentReleaseValue, recentReleaseUnit)

        return HStack {
            Text(self.tool.title)
                .font(.system(size: 12, weight: .medium, design: .default))
                .lineLimit(nil)

            Spacer()

            Text(self.tool.formattedDate)
                .font(.system(size: 10, weight: isRecentRelease == true ? .bold : .light, design: .default))
                .foregroundColor(isRecentRelease == true ? Color("forestgreen") : .secondary)
                .lineLimit(1)
                .onHover(perform: { hover in
                    self.showPopover = hover
                })
                .popover(isPresented: $showPopover) {
                    Text(Self.formatter.string(from: self.tool.date))
                        .foregroundColor(.secondary)
                        .font(.system(.caption))
                        .padding()
            }
        }
        .padding([.vertical], 4)
    }
}

struct ReleasedToolRow_Previews: PreviewProvider {
    static let tool = Tool(
        title: "iOS 14.0",
        link: URL(string: "wwww.apple.com")!,
        description: "New release of iOS 14.0",
        date: Date()
    )

    static var previews: some View {
        ToolRow(tool: Self.tool)
            .frame(width: 300)
    }
}
