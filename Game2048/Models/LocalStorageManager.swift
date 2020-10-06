//
//  LocalStorageManager.swift
//  Game2048
//
//  Created by 向松涛 on 2020/10/4.
//

import Foundation

typealias StoreData = [String: String]

class Storage {
    var _data = StoreData()
    func setItem (_ id: String, _ value: String) {
        _data[id] = String(value);
    }
    func getItem (_ id: String) -> String? {
        return _data[id]
    }
    func removeItem (_ id: String) -> String? {
        return _data.removeValue(forKey: id)
    }
    func clear () -> StoreData {
        _data = StoreData()
        return _data
    }
}

class LocalStorageManager {
    var bestScoreKey = "bestScore"
    var gameStateKey = "gameState"
    var storage = Storage()
    
    // Best score getters/setters
    func getBestScore () -> Int {
        if let bestScore = storage.getItem(bestScoreKey) {
            return Int(bestScore) ?? 0
        }
        return 0
    }
    func setBestScore (_ score: Int) {
        storage.setItem(bestScoreKey, String(score));
    }
    
    // Game state getters/setters and clearing
    func getGameState () -> GameManagerSerialize? {
        let decoder = JSONDecoder()
        
        guard
            let stateJSONString: String = storage.getItem(gameStateKey),
            let gameState = try? decoder.decode(GameManagerSerialize.self, from: stateJSONString.data(using: .utf8)!)
        else {
            return nil
        }
         
        return gameState
    }
    func setGameState (gameState: GameManagerSerialize) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // JSON格式化
        guard
            let encodedData = try? encoder.encode(gameState),
            let _ = String(data: encodedData, encoding: .utf8)
        else {
            fatalError("`JSON Encode Failed`")
        }
    }
    
    func clearGameState () {
        // MARK!
        var _ = storage.removeItem(gameStateKey);
    }
}

