//
//  Grid.swift
//  Game2048
//
//  Created by 向松涛 on 2020/10/4.
//

import Foundation

typealias CellType = [Tile?]
typealias CellsType = [CellType]

struct GridSerialize: Codable {
    var size: Int
    var cells: [[TileSerialize?]]
}


class Grid: Identifiable {
    var size: Int = 4;
    var cells: CellsType = [];
    
    var flattenCells: [Tile] {
        var tmp: [Tile] = [];
        for x in 0..<self.cells.count {
            for y in 0..<self.cells.count {
                if self.cells[x][y] != nil {
                    tmp.append(self.cells[x][y]!)
                }
            }
        }
        return tmp
    }
    
    init (size:Int) {
        self.size = size;
        self.cells = self.empty()
    }
    
    init (size:Int, previousState:[[TileSerialize?]?]) {
        self.size = size;
        self.cells = self.fromState(state: previousState)
    }

    func empty () -> CellsType {
        var cells:[CellType] = Array.init(repeating: [], count: size);
        for x in 0..<size {
            cells[x] = Array.init(repeating: nil, count: size);
        }
        return cells;
    }
    
    
    func fromState (state: [[TileSerialize?]?]) -> CellsType {
        var cells:[CellType] = [];
        for x in 0..<size {
            for y in 0..<size {
                let tileData = state[x]?[y];
                
                if let tile = tileData {
                    cells[x][y] = Tile(position: tile.position, value: tile.value);
                } else {
                    cells[x][y] = nil
                }
            }
        }

        return cells;
    }
    
    // Find the first available random position
    func randomAvailableCell () -> Position? {
        let cells: [Position] = availableCells();

        if (!cells.isEmpty) {
            let randomNum = Int(Int(arc4random()) % cells.count);
            return cells[randomNum];
        }
        return nil
    }
    
    func availableCells () -> [Position] {
        var cells:[Position] = [];

        eachCell { (x, y, tile) in
          if (tile == nil) {
            cells.append(Position( x: x, y: y ));
          }
        };

        return cells;
    }
    
    // // Call callback for every cell
    func eachCell (_ callback: (_ x:Int, _ y:Int, _ tile:Tile?) -> Void) {
        for x in 0..<size {
            for y in 0..<size {
                callback(x, y, cells[x][y]);
            }
        }
    }
    
    func cellsAvailable () -> Bool{
        return availableCells().count > 0;
    }
    
    func cellAvailable (_ cell: Position) -> Bool {
        return !self.cellOccupied(cell);
    }
    func cellOccupied (_ cell: Position) -> Bool {
        return self.cellContent(cell) != nil;
    }
    func cellContent (_ cell: Position) -> Tile? {
        if self.withinBounds(cell) {
            return self.cells[cell.x][cell.y];
        } else {
            return nil;
        }
    }
    
    func insertTile (_ tile: Tile) {
        self.cells[tile.x][tile.y] = tile;
    }
    
    func removeTile (_ tile: Tile) {
        self.cells[tile.x][tile.y] = nil;
    }
    
    func withinBounds (_ position: Position) -> Bool {
        return position.x >= 0 && position.x < self.size &&
               position.y >= 0 && position.y < self.size;
    }
    
    func serialize () -> GridSerialize {
        var cellState:[[TileSerialize?]] = Array.init(repeating: [], count: size);

        for x in 0..<size {
            cellState[x] = Array.init(repeating: nil, count: size);
            for y in 0..<size {
                if !self.cells[x].isEmpty && self.cells[x][y] != nil {
                    cellState[x][y] = self.cells[x][y]!.serialize()
                } else {
                    cellState[x][y] = nil
                }
          }
        }
        
        return GridSerialize(size: self.size, cells: cellState);
    }
}
