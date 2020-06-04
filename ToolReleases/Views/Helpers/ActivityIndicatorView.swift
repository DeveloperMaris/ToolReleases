//
//  ActivityIndicatorView.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 03/06/2020.
//  Copyright © 2020 Developer Maris. All rights reserved.
//

import SwiftUI

struct ActivityIndicatorView: NSViewRepresentable {
    typealias NSViewType = NSProgressIndicator

    @State var spinning = false

    func makeNSView(context: Context) -> NSProgressIndicator {
        let view = NSProgressIndicator()

        view.controlSize = .small
        view.style = .spinning
        view.isIndeterminate = true
        view.isDisplayedWhenStopped = false

        if spinning {
            view.startAnimation(nil)
        }

        return view
    }

    func updateNSView(_ nsView: NSProgressIndicator, context: Context) {
        if spinning {
            nsView.startAnimation(nil)
        } else {
            nsView.stopAnimation(nil)
        }
    }
}
