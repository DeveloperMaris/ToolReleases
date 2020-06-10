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
    private let recentReleaseValue = 3
    private let recentReleaseUnit = Calendar.Component.day

    let tool: Tool

    var body: some View {
        let isRecentRelease = ToolReleaseDateComparison.isTool(tool, releasedLessThan: recentReleaseValue, recentReleaseUnit)

        return VStack(alignment: .leading) {
            Text(self.tool.title)
                .font(.system(size: 12, weight: .medium, design: .default))
                .layoutPriority(1)

            Text(self.tool.formattedDate)
                .font(.system(size: 10, weight: isRecentRelease == true ? .bold : .thin, design: .default))
                .foregroundColor(isRecentRelease == true ? .green : .secondary)

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
