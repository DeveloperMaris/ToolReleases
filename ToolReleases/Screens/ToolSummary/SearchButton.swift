//
//  SearchButton.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 09/07/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import SwiftUI

struct SearchButton: View {
    var handler: () -> Void

    var body: some View {
        Button(action: handler) {
            Label("Search", systemImage: "magnifyingglass")
                .imageScale(.medium)
                .labelStyle(.iconOnly)
        }
        .frame(width: 20, height: 20)
        .buttonStyle(.borderless)
        .foregroundColor(Color(.labelColor))
    }
}

struct SearchButton_Previews: PreviewProvider {
    static var previews: some View {
        SearchButton() {
            // do nothing
        }
    }
}
