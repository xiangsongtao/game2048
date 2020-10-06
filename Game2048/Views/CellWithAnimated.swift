//
//  CellWithAnimated.swift
//  Game2048
//
//  Created by 向松涛 on 2020/10/5.
//

import SwiftUI

struct Cell: View {
    var value: Int = 0
    var valueStyle: (fontColor:Color, backgroundColor: Color, fontSize: CGFloat);
    var size: CGFloat;
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 3)
                .fill(valueStyle.backgroundColor)
            Text(String(value))
                .foregroundColor(valueStyle.fontColor)
                .font(.system(size: valueStyle.fontSize))
                .fontWeight(Font.Weight.heavy)
        }
        .frame(width: size, height: size, alignment: .center)
    }
}

struct NewAddCell: View {
    var value: Int = 0
    var valueStyle: (fontColor:Color, backgroundColor: Color, fontSize: CGFloat);
    var size: CGFloat;
    var position: CGPoint;
    
    @State var scaleSize: CGFloat = 0.001
    @State var opacitySize: Double = 0.001
    
    var body: some View {
        Cell(
            value: self.value,
            valueStyle: self.valueStyle,
            size: self.size
        )
        .animation(nil)
        .opacity(opacitySize)
        .scaleEffect(scaleSize, anchor: .center) // 必须要在position之前
        .position(position)
        .animation(.easeInOut(duration: 0.2))
        .onAppear() {
            withAnimation {
                self.scaleSize = 1
                self.opacitySize = 1
            }
        }
    }
}

struct MargedCell: View {
    var value: Int = 0
    var valueStyle: (fontColor:Color, backgroundColor: Color, fontSize: CGFloat);
    var size: CGFloat;
    var position: CGPoint;
    
    @State var scaleSize: CGFloat = 0.001 // 如果是 0 会有警告
    
    var body: some View {
        Cell(
            value: self.value,
            valueStyle: self.valueStyle,
            size: self.size
        )
        .scaleEffect(scaleSize, anchor: .center) // 必须要在position之前
        .position(position)
        .animation(.marged())
        .onAppear() {
            withAnimation {
                self.scaleSize = 1
            }
        }
    }
}

struct MovedCell: View {
    var value: Int = 0
    var valueStyle: (fontColor:Color, backgroundColor: Color, fontSize: CGFloat);
    var size: CGFloat = 0
    
    var fromPosition: CGPoint = CGPoint(x:0, y:0);
    var toPosition: CGPoint = CGPoint(x:0, y:0);
    
    @State var position: (x: CGFloat, y: CGFloat) = (x:0, y:0);
    
    init (
        value: Int,
        valueStyle: (fontColor:Color, backgroundColor: Color, fontSize: CGFloat),
        size: CGFloat,
        fromPosition: CGPoint,
        toPosition: CGPoint
    ) {
        self.value = value;
        self.valueStyle = valueStyle;
        self.size = size;
        self.fromPosition = fromPosition;
        self.toPosition = toPosition;
    }
    
    var body: some View {
        Cell(
            value: self.value,
            valueStyle: self.valueStyle,
            size: self.size
        )
        .position(self.toPosition)
        .offset(x: self.position.x, y:self.position.y)
        .animation(.easeInOut(duration: 0.2))
        .onAppear() {
            // 执行在这里初始化
            self.position = (
                x: fromPosition.x - toPosition.x,
                y:fromPosition.y - toPosition.y
            );
            withAnimation {
                self.position = (x: 0, y: 0)
            }
        }
    }
}

struct CellWithTile: View {
    @EnvironmentObject var gameManager: GameManager
    
    var tile: Tile;
    
    private var x:Int = 0; // grid 坐标系的x轴 (左上角为 (0,0))
    private var y:Int = 0; // grid 坐标系的y轴 (左上角为 (0,0))
    private var value:Int = 0 // 显示的数值
    
    // private var _size: CGFloat = cellSize // 尺寸
    private var _paddingSize: CGFloat = PaddingSize // padding间距
    
    private func getPosition (_ x: Int, _ y: Int) -> CGPoint {
        let _x = gameManager.cellSize * CGFloat(x) + gameManager.cellSize/2 + _paddingSize * CGFloat(x)
        let _y = gameManager.cellSize * CGFloat(y) + gameManager.cellSize/2 + _paddingSize * CGFloat(y)
        
        return CGPoint(x: _x, y: _y);
    }
    
    #if os(macOS)
    var TileInnerFontSize: CGFloat = 55
    #else
    var TileInnerFontSize: CGFloat = 35
    #endif
    
    private func getValueStyle(_ value: Int) -> (fontColor:Color, backgroundColor: Color, fontSize: CGFloat) {
        switch value {
            case 0:
                return (Color(hex: "776e65"), Color(hex: "eee4da"), TileInnerFontSize)
            case 2:
                return (Color(hex: "776e65"), Color(hex: "eee4da"), TileInnerFontSize)
            case 4:
                return (Color(hex: "776e65"), Color(hex: "ede0c8"), TileInnerFontSize)
            case 8:
                return (Color(hex: "f9f6f2"), Color(hex: "f2b179"), TileInnerFontSize)
            case 16:
                return (Color(hex: "f9f6f2"), Color(hex: "f59563"), TileInnerFontSize)
            case 32:
                return (Color(hex: "f9f6f2"), Color(hex: "f67c5f"), TileInnerFontSize)
            case 64:
                return (Color(hex: "f9f6f2"), Color(hex: "f65e3b"), TileInnerFontSize)
            case 128:
                return (Color(hex: "f9f6f2"), Color(hex: "edcf72"), TileInnerFontSize - 10)
            case 256:
                return (Color(hex: "f9f6f2"), Color(hex: "edcc61"), TileInnerFontSize - 10)
            case 512:
                return (Color(hex: "f9f6f2"), Color(hex: "edc850"), TileInnerFontSize - 10)
            case 1024:
                return (Color(hex: "f9f6f2"), Color(hex: "edc53f"), TileInnerFontSize - 10)
            case 2048:
                return (Color(hex: "f9f6f2"), Color(hex: "edc22e"), TileInnerFontSize - 10)
            default:
                return (Color(hex: "f9f6f2"), Color(hex: "3c3a32"), TileInnerFontSize - 15)
        }
    }
    
    init (tile:Tile) {
        self.tile = tile;
        self.x = tile.x;
        self.y = tile.y;
        self.value = tile.value;
    }

    var body: some View {
        Section {
            if self.tile.previousPosition != nil {
                 MovedCell(
                    value: tile.value,
                    valueStyle: self.getValueStyle(tile.value),
                    size: gameManager.cellSize,
                    fromPosition: self.getPosition(tile.previousPosition!.x, tile.previousPosition!.y),
                    toPosition: self.getPosition(tile.x, tile.y)
                )
            } else if self.tile.mergedFrom != nil {
              
                    ForEach(tile.mergedFrom!) { (tile: Tile) in
                        MovedCell(
                            value: tile.value,
                            valueStyle: self.getValueStyle(tile.value),
                            size: gameManager.cellSize,
                            fromPosition: self.getPosition(tile.previousPosition!.x, tile.previousPosition!.y),
                            toPosition: self.getPosition(tile.x, tile.y)
                        )
                    }

                    MargedCell(
                        value: self.value,
                        valueStyle: self.getValueStyle(self.value),
                        size: gameManager.cellSize,
                        position: self.getPosition(self.x, self.y)
                    )
              
            } else {
                 NewAddCell(
                    value: self.value,
                    valueStyle: self.getValueStyle(self.value),
                    size: gameManager.cellSize,
                    position: self.getPosition(self.x, self.y)
                )
            }
        }
    }
}
