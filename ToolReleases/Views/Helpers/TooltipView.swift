//
//  TooltipView.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 03/06/2020.
//  Copyright © 2020 Developer Maris. All rights reserved.
//

import SwiftUI

struct TooltipView: NSViewRepresentable {
    typealias NSViewType = NSView

    @State var text: String?

    func makeNSView(context: Context) -> NSView {
        let view = NSView()

        view.toolTip = text

        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        nsView.toolTip = text
    }
}
