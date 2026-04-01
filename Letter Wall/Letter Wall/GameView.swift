//
//  GameView.swift
//  Letter Wall
//
//  Created by Joby on 01/04/2026.
//

import SwiftUI

struct GameView: View {
    @State private var gameBoard = GameBoard()
    @State private var showInvalidWord = false
    @State private var showValidWord = false
    @State private var suggestions: [String] = []
    @State private var showGameOver = false
    @State private var finalScore = 0
    @State private var finalWords: [String] = []
    @State private var remainingWordCount: Int? = nil
    @State private var isCalculatingWords = false
    @State private var showHint = false
    @State private var currentHint: String = ""
    
    var body: some View {
        VStack(spacing: 12) {
            // Header
            headerView
            
            // Letter grid (takes more space now)
            letterGridView
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 0.95, green: 0.95, blue: 1.0),
                            Color(red: 1.0, green: 0.95, blue: 0.95)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(12)
                .padding(.horizontal)
            
            // All found words (alphabetically sorted)
            allWordsDisplay
            
            Spacer(minLength: 0)
            
            // Action buttons at bottom
            actionButtonsView
        }
        .padding(.vertical)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.95, blue: 1.0),
                    Color(red: 1.0, green: 0.98, blue: 0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .overlay(alignment: .center) {
            // Success/Error messages overlay the entire view
            if showValidWord {
                VStack(spacing: 4) {
                    Text("✓ Valid Word!")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(red: 0.2, green: 0.6, blue: 0.3))
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.8, green: 1.0, blue: 0.85),
                                    Color(red: 0.7, green: 0.95, blue: 0.75)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .green.opacity(0.3), radius: 10)
                )
                .transition(.scale.combined(with: .opacity))
            }
            
            if showInvalidWord {
                VStack(spacing: 4) {
                    Text("✗ Not in Dictionary")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(red: 0.8, green: 0.2, blue: 0.2))
                    
                    if !suggestions.isEmpty {
                        Text("Did you mean: \(suggestions.prefix(2).joined(separator: ", "))?")
                            .font(.caption)
                            .foregroundStyle(Color(red: 0.6, green: 0.2, blue: 0.2))
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 1.0, green: 0.85, blue: 0.85),
                                    Color(red: 1.0, green: 0.75, blue: 0.75)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .red.opacity(0.3), radius: 10)
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .sheet(isPresented: $showGameOver) {
            GameOverView(
                score: finalScore,
                words: finalWords,
                onNewGame: startNewGame
            )
        }
        .alert("Hint", isPresented: $showHint) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Try finding: \(currentHint.uppercased())")
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Letter Wall")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            HStack(spacing: 40) {
                VStack {
                    Text("Score")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(gameBoard.score)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.blue)
                        .contentTransition(.numericText())
                }
                
                VStack {
                    Text("Words")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(gameBoard.foundWords.count)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.green)
                        .contentTransition(.numericText())
                }
                
                // Current word shown here instead
                VStack {
                    Text("Current")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(gameBoard.currentWord.isEmpty ? "—" : gameBoard.currentWord)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(gameBoard.currentWord.count >= 4 ? .green : .orange)
                        .contentTransition(.numericText())
                }
            }
            
            // Remaining words indicator
            if let count = remainingWordCount {
                HStack(spacing: 4) {
                    Image(systemName: "lightbulb.fill")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                    Text("\(count) possible word\(count == 1 ? "" : "s") remaining")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.orange.opacity(0.1))
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal)
    }
    
    // All words display - shows all found words alphabetically sorted
    private var allWordsDisplay: some View {
        Group {
            if !gameBoard.foundWords.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Found Words (\(gameBoard.foundWords.count))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                    
                    // Use FlowLayout to wrap words across multiple lines
                    ScrollView {
                        FlowLayout(spacing: 6) {
                            ForEach(gameBoard.foundWords.sorted(), id: \.self) { word in
                                Text(word)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 3)
                                    .background(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.7, green: 1.0, blue: 0.8),
                                                Color(red: 0.6, green: 0.9, blue: 0.7)
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .foregroundStyle(Color(red: 0.2, green: 0.5, blue: 0.3))
                                    .cornerRadius(6)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .frame(maxHeight: 100)
            }
        }
    }
    
    // Compact word display - just shows recent words
    private var compactWordDisplay: some View {
        Group {
            if !gameBoard.foundWords.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(gameBoard.foundWords.suffix(5), id: \.self) { word in
                            Text(word)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.7, green: 1.0, blue: 0.8),
                                            Color(red: 0.6, green: 0.9, blue: 0.7)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .foregroundStyle(Color(red: 0.2, green: 0.5, blue: 0.3))
                                .cornerRadius(6)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 24)
            }
        }
    }
    
    
    private var letterGridView: some View {
        GeometryReader { geometry in
            // Calculate tile size with NO gaps (tiles touch each other)
            let tileSize = min(
                geometry.size.width / CGFloat(gameBoard.columns),
                geometry.size.height / CGFloat(gameBoard.rows)
            )
            
            ZStack {
                ForEach(gameBoard.tiles) { tile in
                    LetterTileView(
                        tile: tile,
                        isSelected: gameBoard.isSelected(tile),
                        selectionIndex: gameBoard.selectionIndex(of: tile),
                        animation: gameBoard.isAnimating(tile),
                        tileSize: tileSize,
                        gridRows: gameBoard.rows
                    )
                    .position(
                        x: CGFloat(tile.position.column) * tileSize + tileSize / 2,
                        y: CGFloat(tile.position.row) * tileSize + tileSize / 2
                    )
                    .onTapGesture {
                        print("🖱️ Tap detected on \(tile.letter)")
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            gameBoard.selectTile(tile)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .aspectRatio(CGFloat(gameBoard.columns) / CGFloat(gameBoard.rows), contentMode: .fit)
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                Button(action: {
                    withAnimation {
                        gameBoard.clearSelection()
                    }
                }) {
                    Label("Clear", systemImage: "xmark.circle.fill")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: gameBoard.selectedTiles.isEmpty ? 
                                    [Color.gray.opacity(0.3), Color.gray.opacity(0.2)] :
                                    [Color(red: 1.0, green: 0.7, blue: 0.7), Color(red: 1.0, green: 0.6, blue: 0.6)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .foregroundStyle(gameBoard.selectedTiles.isEmpty ? .gray : Color(red: 0.8, green: 0.2, blue: 0.2))
                        .cornerRadius(12)
                        .shadow(color: gameBoard.selectedTiles.isEmpty ? .clear : .red.opacity(0.3), radius: 5)
                }
                .disabled(gameBoard.selectedTiles.isEmpty)
                
                Button(action: submitWord) {
                    Label("Submit", systemImage: "checkmark.circle.fill")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: gameBoard.currentWord.count >= 4 ?
                                    [Color(red: 0.7, green: 1.0, blue: 0.8), Color(red: 0.6, green: 0.95, blue: 0.7)] :
                                    [Color.gray.opacity(0.3), Color.gray.opacity(0.2)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .foregroundStyle(gameBoard.currentWord.count >= 4 ? Color(red: 0.2, green: 0.6, blue: 0.3) : .gray)
                        .cornerRadius(12)
                        .shadow(color: gameBoard.currentWord.count >= 4 ? .green.opacity(0.3) : .clear, radius: 5)
                }
                .disabled(gameBoard.currentWord.count < 4)
            }
            
            // Hint button
            Button(action: getHint) {
                Label(
                    isCalculatingWords ? "Calculating..." : "Show Hint",
                    systemImage: "lightbulb.fill"
                )
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 1.0, green: 0.9, blue: 0.6),
                            Color(red: 1.0, green: 0.85, blue: 0.5)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .foregroundStyle(Color(red: 0.6, green: 0.5, blue: 0.0))
                .cornerRadius(12)
                .shadow(color: .yellow.opacity(0.3), radius: 5)
            }
            .disabled(isCalculatingWords)
            
            // Concede button
            Button(action: concedeGame) {
                Label("Concede Game", systemImage: "flag.fill")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [
                                Color(red: 1.0, green: 0.85, blue: 0.5),
                                Color(red: 1.0, green: 0.75, blue: 0.4)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .foregroundStyle(Color(red: 0.6, green: 0.4, blue: 0.0))
                    .cornerRadius(12)
                    .shadow(color: .orange.opacity(0.3), radius: 5)
            }
        }
        .padding(.horizontal)
    }
    
    private func submitWord() {
        Task {
            let word = gameBoard.currentWord
            let isValid = await gameBoard.submitWord()
            
            await MainActor.run {
                if isValid {
                    suggestions = []
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        showValidWord = true
                    }
                    
                    Task {
                        try? await Task.sleep(for: .seconds(1))
                        await MainActor.run {
                            withAnimation {
                                showValidWord = false
                            }
                        }
                    }
                    
                    // Recalculate remaining words after successful submission
                    calculateRemainingWords()
                } else {
                    // Get spelling suggestions for invalid word
                    suggestions = DictionaryManager.shared.getSuggestions(for: word)
                    
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        showInvalidWord = true
                    }
                    
                    Task {
                        try? await Task.sleep(for: .seconds(2))
                        await MainActor.run {
                            withAnimation {
                                showInvalidWord = false
                                suggestions = []
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func concedeGame() {
        // Save final score and words BEFORE showing sheet
        finalScore = gameBoard.score
        finalWords = gameBoard.foundWords.sorted()
        
        // Debug: Print to verify values
        print("📊 Conceding game - Score: \(finalScore), Words: \(finalWords.count)")
        
        // Show game over sheet
        showGameOver = true
    }
    
    private func startNewGame() {
        // Reset game state AFTER dismissing
        gameBoard.resetGame()
        showGameOver = false
        remainingWordCount = nil
        
        // Calculate possible words for the new board
        calculateRemainingWords()
    }
    
    private func calculateRemainingWords() {
        guard !isCalculatingWords else { return }
        
        isCalculatingWords = true
        Task {
            let count = await gameBoard.getRemainingWordCount(minLength: 4)
            
            await MainActor.run {
                withAnimation {
                    remainingWordCount = count
                }
                isCalculatingWords = false
            }
        }
    }
    
    private func getHint() {
        guard !isCalculatingWords else { return }
        
        isCalculatingWords = true
        Task {
            if let hint = await gameBoard.getHint(minLength: 4) {
                await MainActor.run {
                    currentHint = hint
                    showHint = true
                    isCalculatingWords = false
                }
            } else {
                await MainActor.run {
                    currentHint = "No more words available!"
                    showHint = true
                    isCalculatingWords = false
                }
            }
        }
    }
}

struct LetterTileView: View {
    let tile: LetterTile
    let isSelected: Bool
    let selectionIndex: Int?
    let animation: TileAnimation?
    let tileSize: CGFloat
    let gridRows: Int
    
    @State private var animationProgress: CGFloat = 0
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    
    // Bright pastel color palette
    private let pastelColors: [Color] = [
        Color(red: 1.0, green: 0.8, blue: 0.8),   // Pastel Pink
        Color(red: 1.0, green: 0.9, blue: 0.7),   // Pastel Peach
        Color(red: 1.0, green: 1.0, blue: 0.7),   // Pastel Yellow
        Color(red: 0.8, green: 1.0, blue: 0.8),   // Pastel Mint
        Color(red: 0.7, green: 0.9, blue: 1.0),   // Pastel Sky Blue
        Color(red: 0.9, green: 0.8, blue: 1.0),   // Pastel Lavender
        Color(red: 1.0, green: 0.85, blue: 0.9),  // Pastel Rose
        Color(red: 0.85, green: 1.0, blue: 0.9),  // Pastel Aqua
        Color(red: 0.95, green: 0.95, blue: 0.7), // Pastel Cream
        Color(red: 0.9, green: 0.7, blue: 0.9),   // Pastel Orchid
    ]
    
    // Get consistent color for this tile based on letter
    private var tileColor: Color {
        if isSelected {
            return Color(red: 0.3, green: 0.5, blue: 1.0) // Bright blue for selection
        }
        
        // Use letter to determine color (consistent per letter)
        let letterIndex = tile.letter.unicodeScalars.first?.value ?? 65
        let colorIndex = Int(letterIndex) % pastelColors.count
        return pastelColors[colorIndex]
    }
    
    // Darker border color (darken the tile color)
    private var borderColor: Color {
        if isSelected {
            return Color(red: 0.2, green: 0.3, blue: 0.8) // Darker blue
        }
        
        // Darken the tile color for the border
        let letterIndex = tile.letter.unicodeScalars.first?.value ?? 65
        let colorIndex = Int(letterIndex) % pastelColors.count
        
        // Create darker version by reducing RGB values
        switch colorIndex {
        case 0: return Color(red: 0.8, green: 0.5, blue: 0.5)   // Darker Pink
        case 1: return Color(red: 0.8, green: 0.6, blue: 0.4)   // Darker Peach
        case 2: return Color(red: 0.8, green: 0.8, blue: 0.4)   // Darker Yellow
        case 3: return Color(red: 0.5, green: 0.7, blue: 0.5)   // Darker Mint
        case 4: return Color(red: 0.4, green: 0.6, blue: 0.8)   // Darker Sky
        case 5: return Color(red: 0.6, green: 0.5, blue: 0.8)   // Darker Lavender
        case 6: return Color(red: 0.8, green: 0.55, blue: 0.6)  // Darker Rose
        case 7: return Color(red: 0.55, green: 0.8, blue: 0.6)  // Darker Aqua
        case 8: return Color(red: 0.75, green: 0.75, blue: 0.4) // Darker Cream
        default: return Color(red: 0.6, green: 0.4, blue: 0.6)  // Darker Orchid
        }
    }
    
    var body: some View {
        ZStack {
            // Outer border (slightly darker)
            RoundedRectangle(cornerRadius: 4)
                .fill(borderColor)
            
            // Inner tile with pastel color
            RoundedRectangle(cornerRadius: 2)
                .fill(tileColor)
                .padding(2) // This creates the border effect
            
            // Letter
            Text(tile.letter)
                .font(.system(size: tileSize * 0.5, weight: .bold, design: .rounded))
                .foregroundStyle(isSelected ? .white : Color(white: 0.3))
                .shadow(color: .white.opacity(0.8), radius: 1, x: 0, y: 1)
            
            // Selection order indicator
            if let index = selectionIndex {
                Circle()
                    .fill(Color.white)
                    .frame(width: tileSize * 0.25, height: tileSize * 0.25)
                    .overlay {
                        Circle()
                            .strokeBorder(borderColor, lineWidth: 2)
                        Text("\(index + 1)")
                            .font(.system(size: tileSize * 0.15, weight: .bold))
                            .foregroundStyle(borderColor)
                    }
                    .shadow(color: .black.opacity(0.3), radius: 2)
                    .offset(x: tileSize * 0.3, y: -tileSize * 0.3)
            }
        }
        .frame(width: tileSize, height: tileSize)
        .scaleEffect(isSelected ? 1.05 : scale)
        .opacity(opacity)
        .onChange(of: animation) { oldValue, newValue in
            handleAnimation(newValue)
        }
        .onAppear {
            // Initial spawn animation if this is a new tile
            if animation?.animationType == .spawning {
                handleAnimation(animation)
            }
        }
    }
    
    private func handleAnimation(_ anim: TileAnimation?) {
        guard let anim = anim else { return }
        
        switch anim.animationType {
        case .removing:
            // Pop out and fade (keep this as is)
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                scale = 1.5
            }
            withAnimation(.easeOut(duration: 0.3)) {
                opacity = 0
            }
            
        case .dropping(let fromRow, let toRow):
            // Tiles already in position, just add a subtle bounce
            withAnimation(
                .spring(
                    response: 0.5,
                    dampingFraction: 0.7
                )
            ) {
                // Small bounce effect
                scale = 1.1
            }
            
            // Return to normal
            Task {
                try? await Task.sleep(for: .milliseconds(200))
                await MainActor.run {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        scale = 1.0
                    }
                }
            }
            
        case .spawning:
            // New tiles spawn from above and slide down
            // Start invisible and above the grid (will animate down via position change)
            scale = 1.0
            opacity = 0
            
            // Fade in and slide down
            withAnimation(
                .spring(
                    response: 0.6,
                    dampingFraction: 0.7
                ).delay(Double(tile.position.column) * 0.05)
            ) {
                opacity = 1.0
            }
        }
    }
}

// MARK: - Game Over View
struct GameOverView: View {
    let score: Int
    let words: [String]
    let onNewGame: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Trophy icon
                Image(systemName: "trophy.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .padding()
                
                // Game Over text
                Text("Game Complete!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Score
                VStack(spacing: 8) {
                    Text("Final Score")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text("\(score)")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundStyle(.blue)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(uiColor: .systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 10)
                )
                
                // Words found
                VStack(spacing: 12) {
                    Text("Words Found: \(words.count)")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 80))
                        ], spacing: 8) {
                            ForEach(words, id: \.self) { word in
                                Text(word)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.7, green: 1.0, blue: 0.8),
                                                Color(red: 0.6, green: 0.9, blue: 0.7)
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .foregroundStyle(Color(red: 0.2, green: 0.5, blue: 0.3))
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                    }
                    .frame(maxHeight: 200)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(uiColor: .secondarySystemBackground))
                    )
                }
                
                Spacer()
                
                // New game button
                Button(action: {
                    // Dismiss first, THEN reset game
                    dismiss()
                    // Small delay to ensure sheet is dismissed before resetting
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onNewGame()
                    }
                }) {
                    Text("Start New Game")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.7, green: 1.0, blue: 0.8),
                                    Color(red: 0.6, green: 0.95, blue: 0.7)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .foregroundStyle(Color(red: 0.2, green: 0.6, blue: 0.3))
                        .cornerRadius(16)
                        .shadow(color: .green.opacity(0.3), radius: 10)
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Game Over")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Flow Layout
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    // Move to next line
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: currentX, y: currentY))
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

#Preview {
    GameView()
}
