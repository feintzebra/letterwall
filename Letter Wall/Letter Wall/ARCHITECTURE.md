//
//  ARCHITECTURE.md
//  Letter Wall - System Architecture
//

# 🏗️ Letter Wall Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                      ContentView.swift                       │
│                    (App Entry Point)                         │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│                       GameView.swift                          │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  UI Layer (SwiftUI)                                  │   │
│  │  • Header with score & word count                    │   │
│  │  • Current word display with hints                   │   │
│  │  • 8x6 letter grid with animations                   │   │
│  │  • Submit & Clear buttons                            │   │
│  │  • Success/Error feedback overlays                   │   │
│  └─────────────────────────────────────────────────────┘   │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
        ┌───────────────┴───────────────┐
        │                               │
        ▼                               ▼
┌──────────────────┐          ┌──────────────────────┐
│  GameBoard.swift │          │ DictionaryManager    │
│                  │          │      .swift          │
│  Game Logic:     │◄────────►│                      │
│  • Tile mgmt     │          │  Validation:         │
│  • Selection     │          │  • UITextChecker     │
│  • Validation    │          │  • UK English        │
│  • Scoring       │          │  • Suggestions       │
│  • Animations    │          │  • Min length        │
└────────┬─────────┘          └──────────────────────┘
         │
         ▼
┌──────────────────┐
│ LetterTile.swift │
│                  │
│  Data Model:     │
│  • Letter char   │
│  • Grid position │
│  • Unique ID     │
│  • Adjacent calc │
└──────────────────┘
```

## 🔄 Data Flow

### Word Submission Flow:
```
1. User taps tiles
   ├→ GameView updates UI
   └→ GameBoard.selectTile()
       └→ Validates adjacency
           └→ Updates selectedTiles[]

2. User clicks Submit
   ├→ GameView.submitWord()
   └→ GameBoard.submitWord()
       ├→ Check min length (4)
       └→ DictionaryManager.isValidWord()
           ├→ UITextChecker.rangeOfMisspelledWord()
           └→ Returns: Valid or Invalid

3a. IF VALID:
    ├→ Add to foundWords[]
    ├→ Update score (word.count * 10)
    ├→ GameBoard.removeSelectedTiles()
    │   ├→ Mark tiles for removal animation
    │   ├→ Wait 300ms
    │   ├→ Delete tiles
    │   └→ GameBoard.applyGravity()
    │       ├→ Process each column (50ms delay)
    │       ├→ Move existing tiles down
    │       ├→ Spawn new tiles at top
    │       └→ Wait 600ms for animations
    └→ GameView shows ✓ success message

3b. IF INVALID:
    ├→ Clear selection
    ├→ DictionaryManager.getSuggestions()
    └→ GameView shows ✗ error with hints
```

## 📦 Component Relationships

### GameView (UI Layer)
```swift
@State private var gameBoard = GameBoard()
@State private var showInvalidWord = false
@State private var showValidWord = false
@State private var suggestions: [String] = []

Dependencies:
├─ GameBoard (owns instance)
├─ LetterTileView (renders each tile)
└─ DictionaryManager (for suggestions)
```

### GameBoard (Business Logic)
```swift
@Observable class GameBoard {
    private(set) var tiles: [LetterTile]
    private(set) var selectedTiles: [LetterTile]
    private(set) var animatingTiles: [TileAnimation]
    
    Dependencies:
    ├─ LetterTile (data model)
    ├─ TileAnimation (animation state)
    └─ DictionaryManager (validation)
}
```

### DictionaryManager (Validation Service)
```swift
@Observable class DictionaryManager {
    private let checker = UITextChecker()
    private let locale = Locale(identifier: "en_GB")
    
    Dependencies:
    └─ UIKit.UITextChecker (system API)
}
```

## 🎬 Animation System

### Three Animation Types:
```
TileAnimation
├─ .removing
│  └─ Scale: 1.0 → 1.5
│     Rotation: 0° → 180°
│     Opacity: 1.0 → 0.0
│     Duration: 300ms
│
├─ .dropping(fromRow, toRow)
│  └─ Position: oldRow → newRow
│     Rotation: distance * 90°
│     Spring: response 0.6, damping 0.6
│     Duration: 600ms + (distance * 50ms)
│
└─ .spawning
   └─ Scale: 0.5 → 1.0
      Rotation: -180° → 0°
      Opacity: 0.0 → 1.0
      Spring: response 0.7, damping 0.5
      Delay: column * 50ms (cascade)
```

### Animation Timeline:
```
Time    Event
────────────────────────────────────────────
0ms     User submits valid word
        ├─ Mark tiles .removing
        
300ms   Removal complete
        ├─ Delete tiles from grid
        └─ Begin column processing
        
350ms   Column 0: Apply gravity
        ├─ Mark tiles .dropping
        └─ Mark new tiles .spawning
        
400ms   Column 1: Apply gravity
        
450ms   Column 2: Apply gravity
        
...     (continue for all columns)
        
650ms   All columns processed
        
1250ms  All animations complete
        └─ Clear animation states
```

## 🗄️ State Management

### Observable Pattern:
```
┌─────────────────────┐
│   @Observable       │
│   GameBoard         │
│                     │
│ When tiles change:  │
│ ├─ SwiftUI notified │
│ ├─ Views recompute  │
│ └─ UI updates       │
└─────────────────────┘
         │
         └─────► Observed by GameView
                          │
                          └─► Renders LetterTileView
                                       │
                                       └─► Shows animations
```

### State Variables:
```swift
// GameBoard (source of truth)
tiles: [LetterTile]              // All tiles on board
selectedTiles: [LetterTile]      // Current selection
animatingTiles: [TileAnimation]  // Animation states
score: Int                       // Current score
foundWords: [String]             // Words found

// GameView (UI state)
showValidWord: Bool              // Success overlay
showInvalidWord: Bool            // Error overlay
suggestions: [String]            // Spelling hints
```

## 🎯 Key Design Patterns

### 1. **Separation of Concerns**
```
GameView  ────► Presentation (UI only)
   │
   ├──► GameBoard ────► Business Logic
   │         │
   │         └──► DictionaryManager ────► Validation Service
   │
   └──► LetterTileView ────► Component (render single tile)
```

### 2. **Dependency Injection**
```swift
// GameView creates GameBoard
@State private var gameBoard = GameBoard()

// GameBoard uses shared DictionaryManager
DictionaryManager.shared.isValidWord(word)
```

### 3. **Async/Await**
```swift
// Clean async validation
func submitWord() async -> Bool {
    let isValid = await isValidWord(word)
    if isValid {
        await removeSelectedTiles()
        return true
    }
    return false
}
```

### 4. **Observable Objects**
```swift
@Observable class GameBoard {
    // Automatic SwiftUI updates
    private(set) var tiles: [LetterTile] = []
}
```

## 📊 Performance Characteristics

### Time Complexity:
```
selectTile():           O(n) - check adjacency
isValidWord():          O(1) - UITextChecker lookup
applyGravity():         O(rows × columns) - per column
removeSelectedTiles():  O(selected) - small constant
```

### Space Complexity:
```
tiles:                  O(rows × columns) ≈ 48 tiles
selectedTiles:          O(k) where k ≤ 48 (max word length)
animatingTiles:         O(k) transient during animations
foundWords:             O(w) where w = words found
```

### Animation Performance:
- Hardware accelerated (Metal/Core Animation)
- 60 FPS target
- Smooth spring physics
- No manual CADisplayLink needed

## 🔐 Validation Chain

### Word Validation Process:
```
User Input: "COLOUR"
     │
     ▼
GameBoard.submitWord()
     │
     ├─ Length check: 6 ≥ 4 ✓
     │
     ▼
DictionaryManager.validateWord()
     │
     ├─ Min length: 6 ≥ 4 ✓
     ├─ Proper noun: "c" is lowercase ✓
     │
     ▼
UITextChecker.rangeOfMisspelledWord()
     │
     ├─ Language: "en_GB"
     ├─ Word: "colour"
     │
     ▼
System Dictionary Lookup
     │
     ├─ Found in UK dictionary ✓
     │
     ▼
Return: NSNotFound (= VALID)
     │
     ▼
Accept word, award points, animate!
```

## 🎨 UI Hierarchy

```
ContentView
 └─ GameView
     ├─ VStack
     │   ├─ headerView
     │   │   ├─ Title
     │   │   ├─ Reset Button
     │   │   └─ Score/Words HStack
     │   │
     │   ├─ currentWordView
     │   │   ├─ Current Word Text
     │   │   ├─ "Need X letters" hint
     │   │   ├─ Recent words ScrollView
     │   │   └─ Overlay (success/error)
     │   │
     │   ├─ letterGridView
     │   │   └─ GeometryReader
     │   │       └─ ZStack
     │   │           └─ ForEach(tiles)
     │   │               └─ LetterTileView
     │   │                   ├─ RoundedRectangle (background)
     │   │                   ├─ Text (letter)
     │   │                   └─ Circle (selection order)
     │   │
     │   └─ actionButtonsView
     │       ├─ Clear Button
     │       └─ Submit Button
     │
     └─ .background (system grouped)
```

## 🧪 Testing Architecture

```
DictionaryTests.swift
 ├─ testValidWords()
 │   └─ Verify UK English acceptance
 │
 ├─ testInvalidWords()
 │   └─ Verify nonsense rejection
 │
 ├─ testShortWords()
 │   └─ Verify 4-letter minimum
 │
 ├─ testCaseInsensitive()
 │   └─ Verify case handling
 │
 └─ testSuggestions()
     └─ Verify spelling hints
```

## 📱 Platform Integration

```
iOS System
 ├─ UITextChecker (Foundation/UIKit)
 │   └─ System dictionary database
 │       ├─ en_GB (British English)
 │       ├─ en_US (American English)
 │       └─ Other variants
 │
 ├─ Metal/Core Animation
 │   └─ Hardware-accelerated animations
 │
 └─ SwiftUI Framework
     ├─ View rendering
     ├─ State management
     └─ Animation system
```

## 🔄 Lifecycle

### App Launch:
```
1. Letter_WallApp.main
2. ContentView loaded
3. GameView initialized
4. GameBoard init(rows: 8, columns: 6)
5. initializeBoard()
6. 48 tiles created with random letters
7. UI rendered
8. Ready for interaction
```

### Game Reset:
```
1. User taps reset button
2. GameView calls gameBoard.resetGame()
3. GameBoard:
   ├─ score = 0
   ├─ foundWords.removeAll()
   ├─ selectedTiles.removeAll()
   └─ initializeBoard() (new 48 tiles)
4. SwiftUI observes changes
5. Views update with animations
```

---

## 📚 File Summary

| File | Purpose | Lines | Key Features |
|------|---------|-------|--------------|
| ContentView.swift | Entry point | 15 | Simple wrapper |
| GameView.swift | UI layer | 268 | All visual components |
| GameBoard.swift | Game logic | 228 | State management |
| LetterTile.swift | Data model | 30 | Tile representation |
| DictionaryManager.swift | Validation | 130 | UK dictionary API |
| DictionaryTests.swift | Testing | 75 | Comprehensive tests |

Total: **746 lines** of production code (excluding docs)

---

**Architecture Design Goals:**
✅ Separation of concerns
✅ Testability
✅ Performance
✅ Maintainability
✅ Extensibility
✅ Apple platform best practices
