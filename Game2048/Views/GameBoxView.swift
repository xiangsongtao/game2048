//
//  GameBox.swift
//  Game2048
//
//  Created by 向松涛 on 2020/10/4.
//

import SwiftUI


struct GameBoxView: View {
    @EnvironmentObject var gameManager: GameManager

    // 手势部分识别
    var drag: some Gesture {
        DragGesture()
            .onEnded { val in
                let touchStartClientX = val.startLocation.x;
                let touchStartClientY = val.startLocation.y;
                let touchEndClientX = val.location.x
                let touchEndClientY = val.location.y
                
                let dx = touchEndClientX - touchStartClientX;
                let absDx = abs(dx);

                let dy = touchEndClientY - touchStartClientY;
                let absDy = abs(dy);
                
                let direction: Direction = absDx > absDy ? (dx > 0 ? Direction.Right : Direction.Left) : (dy > 0 ? Direction.Down : Direction.Up)
                if (max(absDx, absDy) > 10) {
                    gameManager.move(direction)
                 }
            }
    }
    
    var body: some View {
        ZStack {
            Group {
                // 棋盘
                VStack(alignment: .center, spacing: 0) {
                    ChessboardView(size: gameManager.size)
                }
                .frame(width: gameManager.activeSize, height: gameManager.activeSize, alignment: .center)
                .padding(PaddingSize)
                .background(Color(hex: "#bbada0"))
                .cornerRadius(6.0)
                
                // 游戏的方块
                ZStack {
                    ForEach(gameManager.grid.flattenCells) { (tile: Tile) in
                        CellWithTile(tile: tile)
                    }
                }
                .frame(width: gameManager.activeSize, height: gameManager.activeSize, alignment: .topLeading)
            }
            .gesture(drag) // 手势监听

            // 游戏结束 或者 游戏成功的蒙版提示
            if gameManager.terminated {
                if gameManager.over {
                    GameTerminatedView(won: false)
                } else if gameManager.won {
                    GameTerminatedView(won: true)
                }
            }
        }
    }
}

struct GameBoxView_Previews: PreviewProvider {
    static var previews: some View {
        GameBoxView().environmentObject(GameManager())
    }
}
