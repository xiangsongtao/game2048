//
//  Tile.swift
//  Game2048
//
//  Created by 向松涛 on 2020/10/4.
//

import Foundation

struct Position: Codable {
    var x: Int = 0
    var y: Int = 0
}

struct TileSerialize: Codable {
    var position: Position
    var previousPosition: Position?
    var mergedFrom: [Tile]?
    var value: Int
}

class Tile: Identifiable, Codable {
    var x: Int = 0
    var y: Int = 0
    var value: Int = 0
    
    var previousPosition: Position?
    var mergedFrom: [Tile]?

    init (position: Position, value: Int = 2) {
        self.x = position.x
        self.y = position.y
        self.value = value

        self.previousPosition = nil
        self.mergedFrom = nil  // Tracks tiles that merged together
    }
    
    func savePosition () {
        self.previousPosition = Position(x: self.x, y: self.y);
    }
    
    func updatePosition (_ position: Position) {
        self.x = position.x;
        self.y = position.y;
    }
    
    func serialize() -> TileSerialize {
        TileSerialize(
            position: Position(x:self.x, y:self.y),
            previousPosition: self.previousPosition,
            mergedFrom: self.mergedFrom,
            value: self.value
        )
    }
}
