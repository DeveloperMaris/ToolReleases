//
//  ReleasedToolRow.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 09/05/2020.
//  Copyright © 2020 Developer Maris. All rights reserved.
//

import SwiftUI
import ToolReleasesCore

struct ReleasedToolRow: View {
    let tool: Tool
    let recentReleaseDays = 3

    var body: some View {
        let isRecent = isTool(tool, releaseDayLessThan: recentReleaseDays)

        return VStack(alignment: .leading) {
            Text(self.tool.title)
                .font(.system(size: 12, weight: .medium, design: .default))

            Text(self.tool.formattedDate)
                .font(.system(size: 10, weight: isRecent == true ? .bold : .thin, design: .default))
                .foregroundColor(isRecent == true ? .green : .secondary)

        }
        .padding([.vertical], 4)
    }

    /// Checks if the tool was released less than specific amount of days ago.
    /// - Parameters:
    ///   - tool: Provided tool release object.
    ///   - daysAgo: For how many days ago you want to verify the release.
    /// - Returns: Did the tool was release in less than or equal amount of days ago.
    func isTool(_ tool: Tool, releaseDayLessThan daysAgo: Int) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: .now, to: tool.date)

        guard let days = components.day else { return false }

        return abs(days) < daysAgo
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
        ReleasedToolRow(tool: Self.tool)
            .frame(width: 300)
    }
}
