//
//  Letter_WallTests.swift
//  Letter WallTests
//
//  Created by Joby on 01/04/2026.
//

import Testing
@testable import Letter_Wall

@Suite("Dictionary Validation Tests")
struct DictionaryValidationTests {
    
    @Test("Valid UK English words are accepted")
    func testValidWords() async throws {
        let dictionary = DictionaryManager.shared
        
        // Common 4+ letter words
        #expect(dictionary.isValidWord("word"))
        #expect(dictionary.isValidWord("house"))
        #expect(dictionary.isValidWord("great"))
        #expect(dictionary.isValidWord("think"))
        #expect(dictionary.isValidWord("about"))
        
        // UK spellings
        #expect(dictionary.isValidWord("colour"))
        #expect(dictionary.isValidWord("favour"))
        #expect(dictionary.isValidWord("centre"))
        #expect(dictionary.isValidWord("realise"))
        #expect(dictionary.isValidWord("defence"))
    }
    
    @Test("Invalid words are rejected")
    func testInvalidWords() async throws {
        let dictionary = DictionaryManager.shared
        
        // Not real words
        #expect(!dictionary.isValidWord("asdf"))
        #expect(!dictionary.isValidWord("qwerty"))
        #expect(!dictionary.isValidWord("zxcv"))
        #expect(!dictionary.isValidWord("aaaa"))
    }
    
    @Test("Short words are rejected")
    func testShortWords() async throws {
        let dictionary = DictionaryManager.shared
        
        // Less than 4 letters
        #expect(!dictionary.validateWord("cat", minLength: 4))
        #expect(!dictionary.validateWord("the", minLength: 4))
        #expect(!dictionary.validateWord("and", minLength: 4))
        #expect(!dictionary.validateWord("of", minLength: 4))
    }
    
    @Test("Case insensitive validation")
    func testCaseInsensitive() async throws {
        let dictionary = DictionaryManager.shared
        
        #expect(dictionary.isValidWord("WORD"))
        #expect(dictionary.isValidWord("Word"))
        #expect(dictionary.isValidWord("word"))
        #expect(dictionary.isValidWord("WoRd"))
    }
    
    @Test("Suggestions for misspelled words")
    func testSuggestions() async throws {
        let dictionary = DictionaryManager.shared
        
        let suggestions = dictionary.getSuggestions(for: "teh")
        #expect(suggestions.contains("the"))
        
        let suggestions2 = dictionary.getSuggestions(for: "wrod")
        #expect(suggestions2.contains("word"))
    }
}

@Suite("Game Board Tests")
struct GameBoardTests {
    
    @Test("Game board initializes with correct size")
    func testBoardInitialization() async throws {
        let board = GameBoard(rows: 8, columns: 6)
        
        #expect(board.tiles.count == 48) // 8 * 6
        #expect(board.score == 0)
        #expect(board.foundWords.isEmpty)
    }
    
    @Test("Tile selection requires adjacency")
    func testTileAdjacency() async throws {
        let board = GameBoard(rows: 8, columns: 6)
        
        // Get two tiles
        let firstTile = board.tiles.first!
        board.selectTile(firstTile)
        
        #expect(board.selectedTiles.count == 1)
        
        // Try to select non-adjacent tile (should fail)
        let farTile = board.tiles.last!
        board.selectTile(farTile)
        
        // Should still only have 1 tile if they're not adjacent
        if !firstTile.position.isAdjacent(to: farTile.position) {
            #expect(board.selectedTiles.count == 1)
        }
    }
    
    @Test("Clear selection works")
    func testClearSelection() async throws {
        let board = GameBoard(rows: 8, columns: 6)
        
        board.selectTile(board.tiles[0])
        #expect(board.selectedTiles.count == 1)
        
        board.clearSelection()
        #expect(board.selectedTiles.isEmpty)
    }
}

@Suite("Letter Tile Tests")
struct LetterTileTests {
    
    @Test("Adjacent positions are detected")
    func testAdjacency() async throws {
        let pos1 = GridPosition(row: 0, column: 0)
        let pos2 = GridPosition(row: 0, column: 1) // right
        let pos3 = GridPosition(row: 1, column: 0) // below
        let pos4 = GridPosition(row: 1, column: 1) // diagonal
        let pos5 = GridPosition(row: 2, column: 2) // far away
        
        #expect(pos1.isAdjacent(to: pos2))
        #expect(pos1.isAdjacent(to: pos3))
        #expect(pos1.isAdjacent(to: pos4))
        #expect(!pos1.isAdjacent(to: pos5))
    }
    
    @Test("Position is not adjacent to itself")
    func testSelfNotAdjacent() async throws {
        let pos = GridPosition(row: 0, column: 0)
        #expect(!pos.isAdjacent(to: pos))
    }
}

