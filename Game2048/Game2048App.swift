//
//  Game2048App.swift
//  Game2048
//
//  Created by 向松涛 on 2020/10/1.
//

import SwiftUI

@main
struct Game2048App: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(GameManager())
        }
    }
}
