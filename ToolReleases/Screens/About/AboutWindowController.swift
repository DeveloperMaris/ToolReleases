//
//  AboutViewContainer.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 30/06/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import Cocoa
import SwiftUI

class AboutWindowController: NSWindowController {
    let aboutView: AboutView

    init(aboutView: AboutView) {
        self.aboutView = aboutView

        let window = NSWindow(
            contentRect: CGRect(origin: .zero, size: CGSize(width: 650, height: 300)),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = "About"
        window.level = .normal
        window.contentView = NSHostingView(rootView: aboutView)
        window.center()

        super.init(window: window)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func showWindow(_ sender: Any?) {
        NSApp.activate(ignoringOtherApps: true)
        super.showWindow(sender)
    }
}
