//
//  GameData.swift
//  Game2048
//
//  Created by 向松涛 on 2020/10/4.
//

import SwiftUI
import Combine

struct GameManagerSerialize: Codable {
    var grid: GridSerialize
    var score: Int
    var over: Bool
    var won: Bool
    var keepPlaying: Bool
}

enum Direction: Int, CaseIterable {
    case Up = 0;
    case Right = 1;
    case Down = 2;
    case Left = 3;
}

let Size: Int = 4 // 4 x 4 grid
let StartTiles: Int = 2 // 一次填充多少个tile


#if os(macOS)
var ScreenPadding: CGFloat = 160 // 屏幕左右Padding
var PaddingSize: CGFloat = 16 // 棋盘间隔
var ViewWidth: CGFloat = 800
var ViewHeight: CGFloat = 1024
#else
var ScreenPadding: CGFloat = 16 // 屏幕左右Padding
var PaddingSize: CGFloat = 8 // 棋盘间隔
var ViewWidth: CGFloat = UIScreen.main.bounds.width
var ViewHeight: CGFloat = UIScreen.main.bounds.height
#endif

final class GameManager: ObservableObject {
    @Published var size = Size
    @Published var startTiles = StartTiles

    @Published var grid: Grid = Grid(size: Size);
    @Published var score: Int = 0;
    @Published var bestScore: Int = 0; // TODO: HERE
    
    // 状态1: 无路可走, game over
    // 状态2: 达成2048分,
    @Published var terminated: Bool = false // 游戏结束 || (达成2048 && 不再继续)
    @Published var over: Bool = false // 游戏结束, 无法继续移动
    @Published var won: Bool = false // 达成2048才有
    @Published var keepPlaying: Bool = false // 达成2048才有, 继续游戏
    
    
    var gameboxSize: CGFloat {
        CGFloat(ViewWidth - ScreenPadding * 2)
    }
    
    var activeSize: CGFloat {
        CGFloat(gameboxSize - PaddingSize * 2)
    }
    
    var cellSize: CGFloat {
        CGFloat(self.activeSize - (CGFloat(self.size) - 1) * PaddingSize ) / CGFloat(self.size);
    }

    var storageManager = LocalStorageManager()
    
    init () {
        self.setup();
    }
    
    func move (_ direction:Direction) {
        if self.isGameTerminated() {
            return
        }; // Don't do anything if the game's over

        let vector = self.getVector(direction);
        let traversals = self.buildTraversals(vector);
        var moved = false;

        // Save the current tile positions and remove merger information
        self.prepareTiles();

        // Traverse the grid in the right direction and move tiles
        for x in traversals.x {
            for y in traversals.y {
                let cell = Position(x: x, y: y);
                if let tile = self.grid.cellContent(cell) {
                    let positions = self.findFarthestPosition(cell, vector);
                    let next = self.grid.cellContent(positions.next!)
                        // Only one merger per row traversal?
                    if next != nil && next!.value == tile.value && (next!.mergedFrom == nil) {
                        let merged = Tile(position: positions.next!, value: tile.value * 2);
                        merged.mergedFrom = [tile, next!];
        
                        self.grid.insertTile(merged);
                        self.grid.removeTile(tile);

                        // Converge the two tiles' positions
                        tile.updatePosition(positions.next!);

                        // Update the score
                        self.score += merged.value;

                        // The mighty 2048 tile
                        if merged.value == 2048 {
                            self.won = true
                        }
                    } else {
                        self.moveTile(tile, positions.farthest);
                    }
                  
                    if (!self.positionsEqual(Position(x:cell.x,y:cell.y), Position(x:tile.x,y:tile.y) )) {
                      moved = true; // The tile moved from its original cell!
                    }
                }
            }
        }
        
        if (moved) {
            self.addRandomTile()

            if (!self.movesAvailable()) {
                self.over = true; // Game over!
            }

            self.actuate();
          }
    }
    
    func continueGame () {
        self.terminated = false;
    }
    
    // Restart the game
    func restart () {
        self.storageManager.clearGameState();
        self.continueGame(); // Clear the game won/lost message
        self.setup();
    }
    
    // Keep playing after winning (allows going over 2048)
    func doKeepPlaying () {
        self.keepPlaying = true;
        self.continueGame(); // Clear the game won/lost message
    }
    
    private func setup () {
        if let previousState = storageManager.getGameState() {
            self.grid = Grid(size: previousState.grid.size, previousState: previousState.grid.cells); // Reload grid
            self.score = previousState.score;
            self.over = previousState.over;
            self.won = previousState.won;
            self.keepPlaying = previousState.keepPlaying;
        } else {
            self.grid = Grid(size: self.size);
            self.score = 0;
            self.over = false;
            self.won = false;
            self.terminated = false;
            self.won = false;
            self.keepPlaying = false;
              // Add the initial tiles
            
            self.addStartTiles();
        }
        
        self.actuate();
    }
    
    private func addStartTiles () {
        for _ in 0..<self.startTiles {
            self.addRandomTile();
        }
    }
    
    private func addRandomTile () {
        if (self.grid.cellsAvailable()) {
            let value = Int(arc4random() % 10) < 9 ? 2 : 4; // 随机给2或者4
            let tile = Tile(position: self.grid.randomAvailableCell()!, value: value);
            self.grid.insertTile(tile);
         }
    }
    
    private func actuate () {
        if (self.storageManager.getBestScore() < self.score) {
            self.storageManager.setBestScore(self.score);
        }

        // Clear the state when the game is over (game over only, not win)
        if (self.over) {
            self.storageManager.clearGameState();
        } else {
            self.storageManager.setGameState(gameState: self.serialize());
        }

        // update UI
        self.bestScore = self.storageManager.getBestScore()
        self.terminated = self.isGameTerminated()
    }
    
    private func serialize () -> GameManagerSerialize {
        return GameManagerSerialize(
            grid:        self.grid.serialize(),
            score:       self.score,
            over:        self.over,
            won:         self.won,
            keepPlaying: self.keepPlaying
          );
    }
    
    private func isGameTerminated () -> Bool {
        return self.over || (self.won && !self.keepPlaying);
    }
    
    // Get the vector representing the chosen direction
    private func getVector (_ direction: Direction) -> Position {
        // Vectors representing tile movement
        switch direction {
            case .Up:
                return Position(x: 0,  y: -1)
            case .Right:
                return Position(x: 1,  y: 0)
            case .Down:
                return Position(x: 0,  y: 1)
            case .Left:
                return Position(x: -1, y: 0)
        }
    }
    
    // Build a list of positions to traverse in the right order
    private func buildTraversals(_ vector: Position) -> (x: [Int], y: [Int]) {
        var traversals = (x: [Int](), y: [Int]());

        for pos in 0..<self.size {
            traversals.x.append(pos);
            traversals.y.append(pos);
        }
    
         // Always traverse from the farthest cell in the chosen direction
        if vector.x == 1 {
            traversals.x.reverse()
        }
        if vector.y == 1 {
            traversals.y.reverse();
        }

        return traversals;
    }
    
    // Save all tile positions and remove merger info
    private func prepareTiles () {
        self.grid.eachCell { x, y, tile in
          if let _tile = tile {
            _tile.mergedFrom = nil;
            _tile.savePosition();
          }
        };
    }
    
    // Move a tile and its representation
    private func moveTile (_ tile:Tile, _ cell:Position) {
        self.grid.cells[tile.x][tile.y] = nil;
        self.grid.cells[cell.x][cell.y] = tile;
        tile.updatePosition(cell);
    }
    
    private func movesAvailable () -> Bool {
        return self.grid.cellsAvailable() || self.tileMatchesAvailable();
    }
    
    // Check for available matches between tiles (more expensive check)
    private func tileMatchesAvailable () -> Bool {
        for x in 0..<self.size {
            for y in 0..<self.size {
                if let tile = self.grid.cellContent(Position(x: x, y: y)) {

                for direction in Direction.allCases {
                    let vector = self.getVector(direction);
                    let cell   = Position(x: x + vector.x, y: y + vector.y);

                    if let other  = self.grid.cellContent(cell) {
                        if other.value == tile.value {
                            return true; // These two tiles can be merged
                        }
                    }
                }
            }
          }
        }

        return false;
    }
    
    private func findFarthestPosition (_ cell: Position, _ vector: Position) -> (farthest:Position, next: Position?) {
        var previous: Position;
        var next: Position = cell;
        // Progress towards the vector direction until an obstacle is found
        repeat {
          previous = next;
          next = Position(x: previous.x + vector.x, y: previous.y + vector.y);
        } while (self.grid.withinBounds(next) && self.grid.cellAvailable(next));

        return (
          farthest: previous,
          next: next // Used to check if a merge is required
        );
    }
    
    private func positionsEqual (_ first: Position, _ second: Position) -> Bool {
        return first.x == second.x && first.y == second.y;
    }
}
