//
//  DictionaryTestExamples.swift
//  Letter Wall
//
//  Test Examples Documentation
//  (See Letter_WallTests.swift for actual tests)
//

/*
 DICTIONARY TEST EXAMPLES
 ========================
 
 This file documents the test cases for the dictionary validation system.
 The actual tests are in the test target (Letter_WallTests.swift).
 
 TEST SUITES:
 
 1. DICTIONARY VALIDATION TESTS
    ✓ Valid UK English words are accepted
    ✓ Invalid words are rejected
    ✓ Short words are rejected (< 4 letters)
    ✓ Case insensitive validation works
    ✓ Suggestions for misspelled words
 
 2. GAME BOARD TESTS
    ✓ Game board initializes with correct size (8x6 = 48 tiles)
    ✓ Tile selection requires adjacency
    ✓ Clear selection works
 
 3. LETTER TILE TESTS
    ✓ Adjacent positions are detected correctly
    ✓ Position is not adjacent to itself
 
 EXAMPLE TEST WORDS:
 ===================
 
 Valid UK Words (should pass):
 - word, house, great, think, about
 - colour, favour, centre, realise, defence
 
 Invalid Words (should fail):
 - asdf, qwerty, zxcv, aaaa
 
 Short Words (should fail with minLength: 4):
 - cat, the, and, of
 
 Case Variations (all should pass):
 - WORD, Word, word, WoRd
 
 Spelling Suggestions:
 - "teh" → suggests "the"
 - "wrod" → suggests "word"
 
 RUNNING TESTS:
 ==============
 
 In Xcode:
 1. Press Cmd+U to run all tests
 2. Or click the diamond icons in the gutter
 3. View results in the Test Navigator
 
 Using Command Line:
 xcodebuild test -scheme "Letter Wall"
 
 TEST COVERAGE:
 ==============
 
 Components tested:
 ✅ DictionaryManager validation
 ✅ GameBoard initialization
 ✅ Tile selection logic
 ✅ Adjacent position detection
 ✅ Word validation flow
 
 Components not yet tested:
 ⚠️ Animation timing
 ⚠️ Gravity/tile dropping
 ⚠️ Score calculation
 ⚠️ UI interaction
 
 FUTURE TEST IDEAS:
 ==================
 
 - Test that valid words score correctly (word.count * 10)
 - Test that tiles drop correctly after word removal
 - Test that new tiles spawn at top
 - Test that animations complete properly
 - Test game reset functionality
 - Test score accumulation across multiple words
 - Performance test with many tiles
 - Memory leak test with repeated games
 
 */

