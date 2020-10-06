//
//  ContentView.swift
//  Game2048ForMac
//
//  Created by 向松涛 on 2020/10/6.
//

import SwiftUI

struct MacContentView : View {
    var manager: GameManager;
    var body: some View {
        ContentView()
            .environmentObject(manager)
    }
}

class GameHostingView: NSHostingView<MacContentView> {
    
    private var gameManager: GameManager = GameManager();

    init() {
        super.init(rootView: MacContentView(manager: gameManager))
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(rootView: MacContentView) {
        fatalError("init(rootView:) should not be called directly")
    }
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override var mouseDownCanMoveWindow: Bool {
        return true
    }
    
    override func keyDown(with event: NSEvent) {
        guard !event.isARepeat else {
            return
        }

        switch event.keyCode {
            case 1, 125:
                self.gameManager.move(Direction.Down)
            case 0, 123:
                self.gameManager.move(Direction.Left)
            case 2, 124:
                self.gameManager.move(Direction.Right)
            case 13, 126:
                self.gameManager.move(Direction.Up)
            case 49:
                // space button for random action
                let random = Int(arc4random() % 100);
                if random < 25 {
                    self.gameManager.move(Direction.Up)
                } else if random < 50 {
                    self.gameManager.move(Direction.Right)
                } else if random < 75 {
                    self.gameManager.move(Direction.Down)
                } else {
                    self.gameManager.move(Direction.Left)
                }
            default:
                return
        }
    }
}
