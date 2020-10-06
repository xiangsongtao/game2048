//
//  ChessboardView.swift
//  Game2048
//
//  Created by 向松涛 on 2020/10/5.
//

import SwiftUI

// 待合并
struct GameCell: View {
    @EnvironmentObject var gameManager: GameManager
    
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color(hex: "#eee4da59"))
            .frame(width: gameManager.cellSize, height: gameManager.cellSize, alignment: .center)
    }
}

struct GameRow: View {
    var size: Int = 4;
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(0..<size) { index in
                if index == size - 1 {
                    GameCell()
                } else {
                    GameCell().padding(.trailing, PaddingSize)
                }
            }
        }
    }
}


// 棋盘
struct ChessboardView: View {
    var size: Int = 4;
    var body: some View {
        ForEach(0..<size) { index in
            if index == size - 1 {
                GameRow(size:size)
            } else {
                GameRow(size:size).padding(.bottom, PaddingSize)
            }
        }
    }
}

struct ChessboardView_Previews: PreviewProvider {
    static var previews: some View {
        ChessboardView()
    }
}
