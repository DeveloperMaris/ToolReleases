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
            Image(systemName: "magnifyingglass")
        }
        .buttonStyle(BorderlessButtonStyle())
        .foregroundColor(Color(.labelColor))
        .frame(width: 20, height: 20)
    }
}

struct SearchButton_Previews: PreviewProvider {
    static var previews: some View {
        SearchButton {
            // do nothing
        }
    }
}
