//
//  ContentView.swift
//  Game2048
//
//  Created by 向松涛 on 2020/10/1.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameManager: GameManager

    #if os(macOS)
    var Padding: CGFloat = 16
    #else
    var Padding: CGFloat = 8
    #endif

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            HStack(alignment: .center) {

                TitleView()

                Spacer()

                // scoreboard view
                ScoreboardView(boxName: "SCORE", score: gameManager.score)
                ScoreboardView(boxName: "BEST", score: gameManager.bestScore)
            }

            ControlView()
                    .padding(.vertical, Padding)

            // game area
            GameBoxView()

            // desc how to game
            NoticeView()
                    .padding(.vertical, Padding * 2)

            Spacer()

        }
                .padding(.vertical, 10)
                .padding(.horizontal, ScreenPadding)
                .frame(width: ViewWidth, height: ViewHeight)
                .background(Color(hex: "#faf8ef"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
