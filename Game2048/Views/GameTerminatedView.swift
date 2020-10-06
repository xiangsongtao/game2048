//
//  GameTerminatedView.swift
//  Game2048
//
//  Created by 向松涛 on 2020/10/5.
//

import SwiftUI

struct GameTerminatedView: View {
    @EnvironmentObject var gameManager: GameManager
    
    var won: Bool;
    @State var opacify: Double = 0
    
    struct ButtonText: View {
        var text: String = ""
        var body: some View {
            Text(text)
                .foregroundColor(Color(hex: "#f9f6f2"))
                .font(.system(size: 15))
                .fontWeight(Font.Weight.heavy)
                .padding(.horizontal, 20)
                .frame(height: 40)
                .background(Color(hex: "#8f7a66"))
                .cornerRadius(3)
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(won ? "You win!" : "Game over!")
                .font(.system(size: 30))
                .foregroundColor(Color(hex: won ?  "#f9f6f2" : "#776e65"))
                .fontWeight(Font.Weight.heavy)
                .padding(.bottom, 30)
            HStack(alignment: .center, spacing: 16) {
                if won {
                    Button(action: {
                        gameManager.doKeepPlaying()
                    }) {
                        ButtonText(text: "Keep Going")
                    }.buttonStyle(BorderlessButtonStyle())
                }
                
                Button(action: {
                    gameManager.restart()
                }) {
                    ButtonText(text: "Try Again!")
                }.buttonStyle(BorderlessButtonStyle())
            }
        }
        .frame(width: gameManager.gameboxSize, height: gameManager.gameboxSize, alignment: .center)
        .background(Color(hex: won ? "#edc22e80" : "#eee4da80"))
        .cornerRadius(6.0)
        .opacity(opacify)
        .animation(.easeInOut(duration: 0.3))
        .onAppear() {
            self.opacify = 1
        }
    }
}
