//
//  AppDelegate.swift
//  Game2048ForMac
//
//  Created by 向松涛 on 2020/10/6.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = GameHostingView()

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 800),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        
        window.titlebarAppearsTransparent = false
        window.isMovableByWindowBackground = true // true表示关闭鼠标拖拽能力
        
        window.center()
        window.setFrameAutosaveName("Game2048")

        window.contentView = contentView

        window.makeKeyAndOrderFront(nil)
        window.makeFirstResponder(window.contentView)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

