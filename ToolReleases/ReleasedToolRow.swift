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
    var tool: Tool

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(self.tool.title)
                    .font(.system(size: 12, weight: .medium, design: .default))

                Text(self.tool.formattedDate)
                    .font(.system(size: 10, weight: .thin, design: .default))
            }
            Spacer()
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
        ReleasedToolRow(tool: Self.tool)
            .frame(width: 300)
    }
}
