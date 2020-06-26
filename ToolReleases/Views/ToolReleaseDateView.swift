//
//  ToolReleaseDateView.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 26/06/2020.
//  Copyright © 2020 Developer Maris. All rights reserved.
//

import SwiftUI

struct ToolReleaseDateView: View {
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()

        formatter.dateStyle = .full
        formatter.timeStyle = .short

        return formatter
    }()

    let date: Date

    var body: some View {
        Text(Self.formatter.string(from: date))
            .foregroundColor(.secondary)
            .font(.system(.caption))
            .padding()
    }
}

struct ToolReleaseDateView_Previews: PreviewProvider {
    static var previews: some View {
        ToolReleaseDateView(date: Date())
    }
}
