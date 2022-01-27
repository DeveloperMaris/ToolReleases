//
//  LastRefreshView.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 09/07/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import SwiftUI

struct LastRefreshView: View {
    var isRefreshing: Bool
    var lastRefreshDate: Date?
    var handler: () -> Void

    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()

        formatter.dateStyle = .short
        formatter.timeStyle = .short

        return formatter
    }()

    private var formattedLastRefreshDate: String {
        if let date = lastRefreshDate {
            return "Last refresh: \(Self.formatter.string(from: date))"
        }

        return "Data hasn't loaded yet"
    }

    var body: some View {
        HStack {
            Text(formattedLastRefreshDate)
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()

            Group {
                if isRefreshing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(0.5)
                } else {
                    Button(action: handler) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .foregroundColor(Color(.labelColor))
                    .disabled(isRefreshing)
                }
            }
            .frame(width: 16, height: 16)
        }
    }
}

struct LastRefreshView_Previews: PreviewProvider {
    static var previews: some View {
        LastRefreshView(isRefreshing: false, lastRefreshDate: Date()) { }
    }
}
