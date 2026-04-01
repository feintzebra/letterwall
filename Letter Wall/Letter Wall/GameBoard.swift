//
//  GameBoard.swift
//  Letter Wall
//
//  Created by Joby on 01/04/2026.
//

import Foundation
import SwiftUI

struct TileAnimation: Equatable {
    let tileId: UUID
    let animationType: AnimationType
    
    enum AnimationType: Equatable {
        case removing
        case dropping(fromRow: Int, toRow: Int)
        case spawning
    }
}

@Observable
class GameBoard {
    private(set) var tiles: [LetterTile] = []
    private(set) var selectedTiles: [LetterTile] = []
    private(set) var score: Int = 0
    private(set) var foundWords: [String] = []
    private(set) var animatingTiles: [TileAnimation] = []
    
    let rows: Int
    let columns: Int
    
    // Letter frequency distribution (approximate English distribution)
    private let letterWeights: [String: Int] = [
        "A": 8, "B": 2, "C": 3, "D": 4, "E": 12, "F": 2, "G": 3, "H": 6,
        "I": 7, "J": 1, "K": 1, "L": 4, "M": 2, "N": 7, "O": 8, "P": 2,
        "Q": 1, "R": 6, "S": 6, "T": 9, "U": 3, "V": 1, "W": 2, "X": 1,
        "Y": 2, "Z": 1
    ]
    
    init(rows: Int = 5, columns: Int = 5) {
        self.rows = rows
        self.columns = columns
        initializeBoard()
    }
    
    private func initializeBoard() {
        tiles = []
        for row in 0..<rows {
            for col in 0..<columns {
                let letter = randomLetter()
                let tile = LetterTile(letter: letter, position: GridPosition(row: row, column: col))
                tiles.append(tile)
            }
        }
    }
    
    private func randomLetter() -> String {
        let weightedLetters = letterWeights.flatMap { letter, weight in
            Array(repeating: letter, count: weight)
        }
        return weightedLetters.randomElement() ?? "A"
    }
    
    func selectTile(_ tile: LetterTile) {
        print("🎯 selectTile called for: \(tile.letter) at (\(tile.position.row), \(tile.position.column))")
        
        // If already selected, deselect from end of chain
        if let index = selectedTiles.firstIndex(of: tile) {
            print("   Already selected at index \(index)")
            // Allow deselecting only the last tile
            if index == selectedTiles.count - 1 {
                print("   ✓ Deselecting last tile")
                selectedTiles.removeLast()
            } else {
                print("   ✗ Can only deselect last tile")
            }
            return
        }
        
        // If first tile or adjacent to last selected tile
        if selectedTiles.isEmpty {
            print("   ✓ First tile selected")
            selectedTiles.append(tile)
        } else if let lastTile = selectedTiles.last {
            let isAdjacent = tile.position.isAdjacent(to: lastTile.position)
            print("   Last tile: \(lastTile.letter) at (\(lastTile.position.row), \(lastTile.position.column))")
            print("   Adjacent: \(isAdjacent)")
            if isAdjacent {
                print("   ✓ Adding adjacent tile")
                selectedTiles.append(tile)
            } else {
                print("   ✗ Not adjacent to last tile")
            }
        }
        
        print("   Current selection: \(selectedTiles.map { $0.letter }.joined())")
    }
    
    func clearSelection() {
        selectedTiles.removeAll()
    }
    
    var currentWord: String {
        selectedTiles.map { $0.letter }.joined()
    }
    
    func submitWord() async -> Bool {
        let word = currentWord
        guard word.count >= 4 else {
            clearSelection()
            return false
        }
        
        // Check if word is valid using UK English dictionary
        let isValid = await isValidWord(word)
        
        if isValid {
            foundWords.append(word)
            score += calculateScore(word)
            await removeSelectedTiles()
            return true
        } else {
            clearSelection()
            return false
        }
    }
    
    private func calculateScore(_ word: String) -> Int {
        // Base score: 10 points per letter
        return word.count * 10
    }
    
    private func removeSelectedTiles() async {
        let tilesToRemove = selectedTiles
        selectedTiles.removeAll()
        
        // Mark tiles for removal animation
        for tile in tilesToRemove {
            animatingTiles.append(TileAnimation(tileId: tile.id, animationType: .removing))
        }
        
        // Wait for removal animation
        try? await Task.sleep(for: .milliseconds(300))
        
        // Actually remove the tiles
        for tile in tilesToRemove {
            if let index = tiles.firstIndex(of: tile) {
                tiles.remove(at: index)
            }
        }
        
        // Clear removal animations
        animatingTiles.removeAll { animation in
            tilesToRemove.contains { $0.id == animation.tileId }
        }
        
        // Apply gravity with staggered animation
        await applyGravity()
    }
    
    private func applyGravity() async {
        // Process each column with staggered timing
        for col in 0..<columns {
            var columnTiles = tiles.filter { $0.position.column == col }
                .sorted { $0.position.row > $1.position.row }
            
            let emptySpaces = rows - columnTiles.count
            
            // Move existing tiles down with animation tracking
            var newRow = rows - 1
            for i in 0..<columnTiles.count {
                if let index = tiles.firstIndex(where: { $0.id == columnTiles[i].id }) {
                    let oldRow = tiles[index].position.row
                    let targetRow = newRow
                    
                    if oldRow != targetRow {
                        // Add dropping animation
                        animatingTiles.append(TileAnimation(
                            tileId: tiles[index].id,
                            animationType: .dropping(fromRow: oldRow, toRow: targetRow)
                        ))
                    }
                    
                    tiles[index].position.row = targetRow
                    newRow -= 1
                }
            }
            
            // Create new tiles above the grid and drop them in
            for emptyIndex in 0..<emptySpaces {
                let newTile = LetterTile(
                    letter: randomLetter(),
                    position: GridPosition(row: emptyIndex, column: col)
                )
                
                // Mark as spawning
                animatingTiles.append(TileAnimation(
                    tileId: newTile.id,
                    animationType: .spawning
                ))
                
                tiles.append(newTile)
            }
            
            // Small delay between columns for cascade effect
            try? await Task.sleep(for: .milliseconds(50))
        }
        
        // Wait for all animations to complete
        try? await Task.sleep(for: .milliseconds(600))
        
        // Clear all animations
        animatingTiles.removeAll()
    }
    
    func isAnimating(_ tile: LetterTile) -> TileAnimation? {
        animatingTiles.first { $0.tileId == tile.id }
    }
    
    func isSelected(_ tile: LetterTile) -> Bool {
        selectedTiles.contains(tile)
    }
    
    func selectionIndex(of tile: LetterTile) -> Int? {
        selectedTiles.firstIndex(of: tile)
    }
    
    // Word validation using UK English dictionary
    private func isValidWord(_ word: String) async -> Bool {
        // Use the system dictionary for validation
        let dictionary = DictionaryManager.shared
        
        // Debug: Print what we're checking
        print("🔍 Validating word: '\(word)' (length: \(word.count))")
        
        // Validate against UK English dictionary (4+ letters)
        let isValid = dictionary.validateWord(word, minLength: 4, allowProperNouns: false)
        
        // Debug: Print result
        print("✅ Word '\(word)' is valid: \(isValid)")
        
        if !isValid {
            // Get suggestions for debugging
            let suggestions = dictionary.getSuggestions(for: word)
            print("💡 Suggestions: \(suggestions)")
        }
        
        return isValid
    }
    
    func resetGame() {
        score = 0
        foundWords.removeAll()
        selectedTiles.removeAll()
        initializeBoard()
    }
    
    // MARK: - Possible Words Analysis
    
    /// Find all possible valid words that can be formed on the current board
    /// - Parameters:
    ///   - minLength: Minimum word length to search for (default: 4)
    ///   - excludeFound: Whether to exclude already found words (default: true)
    /// - Returns: Set of all possible valid words
    func findAllPossibleWords(minLength: Int = 4, excludeFound: Bool = true) async -> Set<String> {
        var candidateWords = Set<String>()
        
        print("🔍 Step 1: Finding all possible letter combinations...")
        let startTime = Date()
        
        // First pass: Find all possible letter combinations (no dictionary check yet)
        for startTile in tiles {
            var visited = Set<UUID>()
            var currentPath: [LetterTile] = []
            
            // Use depth-first search to explore all paths
            findPaths(
                from: startTile,
                visited: &visited,
                path: &currentPath,
                candidates: &candidateWords,
                minLength: minLength
            )
        }
        
        let elapsed1 = Date().timeIntervalSince(startTime)
        print("   Found \(candidateWords.count) candidate paths in \(String(format: "%.2f", elapsed1))s")
        
        // Second pass: Validate candidates against dictionary
        print("🔍 Step 2: Validating against dictionary...")
        let dictionary = DictionaryManager.shared
        var validWords = Set<String>()
        var checkedCount = 0
        
        for word in candidateWords {
            let isValid = dictionary.validateWord(word, minLength: minLength, allowProperNouns: false)
            if isValid {
                validWords.insert(word)
            }
            
            checkedCount += 1
            // Yield control periodically to keep UI responsive
            if checkedCount % 50 == 0 {
                await Task.yield()
            }
        }
        
        let elapsed2 = Date().timeIntervalSince(startTime)
        print("✅ Found \(validWords.count) valid words in \(String(format: "%.2f", elapsed2))s total")
        
        // Optionally exclude already found words
        if excludeFound {
            validWords = validWords.subtracting(foundWords)
        }
        
        return validWords
    }
    
    /// Non-async path finding (just builds candidate words)
    private func findPaths(
        from tile: LetterTile,
        visited: inout Set<UUID>,
        path: inout [LetterTile],
        candidates: inout Set<String>,
        minLength: Int
    ) {
        // Add current tile to path
        visited.insert(tile.id)
        path.append(tile)
        
        // Form current word
        let currentWord = path.map { $0.letter }.joined()
        
        // If word is long enough, add to candidates
        if currentWord.count >= minLength {
            candidates.insert(currentWord)
        }
        
        // Don't explore paths longer than 12 letters
        if currentWord.count < 12 {
            // Continue exploring adjacent tiles
            for adjacentTile in tiles where !visited.contains(adjacentTile.id) {
                if adjacentTile.position.isAdjacent(to: tile.position) {
                    findPaths(
                        from: adjacentTile,
                        visited: &visited,
                        path: &path,
                        candidates: &candidates,
                        minLength: minLength
                    )
                }
            }
        }
        
        // Backtrack
        visited.remove(tile.id)
        path.removeLast()
    }
    
    /// Get count of remaining possible words (not yet found)
    func getRemainingWordCount(minLength: Int = 4) async -> Int {
        let possibleWords = await findAllPossibleWords(minLength: minLength, excludeFound: true)
        return possibleWords.count
    }
    
    /// Get a hint - returns a random unfound word
    func getHint(minLength: Int = 4) async -> String? {
        let possibleWords = await findAllPossibleWords(minLength: minLength, excludeFound: true)
        return possibleWords.randomElement()
    }
}
