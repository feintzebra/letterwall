//
//  LetterTile.swift
//  Letter Wall
//
//  Created by Joby on 01/04/2026.
//

import Foundation

struct LetterTile: Identifiable, Equatable {
    let id = UUID()
    let letter: String
    var position: GridPosition
    
    static func == (lhs: LetterTile, rhs: LetterTile) -> Bool {
        lhs.id == rhs.id
    }
}

struct GridPosition: Equatable {
    var row: Int
    var column: Int
    
    /// Check if this position is adjacent (including diagonal) to another
    func isAdjacent(to other: GridPosition) -> Bool {
        let rowDiff = abs(row - other.row)
        let colDiff = abs(column - other.column)
        return (rowDiff <= 1 && colDiff <= 1) && !(rowDiff == 0 && colDiff == 0)
    }
}
