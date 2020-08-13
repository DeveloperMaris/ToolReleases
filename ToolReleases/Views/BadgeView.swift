//
//  BadgeView.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 10/08/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import SwiftUI

struct BadgeView: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.red)
                .opacity(0.8)

            Text("•")
                .foregroundColor(.white)
                .font(.system(size: 6))
        }
        .frame(width: 10, height: 10)
    }
}

struct BadgeView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeView()
    }
}
