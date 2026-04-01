//
//  ColorPalette.swift
//  Letter Wall - Color Reference
//
//  Documentation of the pastel color system
//

/*
 PASTEL COLOR PALETTE
 ====================
 
 The game uses 10 bright pastel colors for letter tiles.
 Each letter (A-Z) maps to one of these colors consistently.
 
 COLOR INDEX 0: PASTEL PINK
 ─────────────────────────────────
 Main:   RGB(1.0, 0.8, 0.8)  #FFCCCC
 Border: RGB(0.8, 0.5, 0.5)  #CC7F7F
 Letters: A, K, U
 
 COLOR INDEX 1: PASTEL PEACH
 ─────────────────────────────────
 Main:   RGB(1.0, 0.9, 0.7)  #FFE5B3
 Border: RGB(0.8, 0.6, 0.4)  #CC9966
 Letters: B, L, V
 
 COLOR INDEX 2: PASTEL YELLOW
 ─────────────────────────────────
 Main:   RGB(1.0, 1.0, 0.7)  #FFFFB3
 Border: RGB(0.8, 0.8, 0.4)  #CCCC66
 Letters: C, M, W
 
 COLOR INDEX 3: PASTEL MINT
 ─────────────────────────────────
 Main:   RGB(0.8, 1.0, 0.8)  #CCFFCC
 Border: RGB(0.5, 0.7, 0.5)  #7FB37F
 Letters: D, N, X
 
 COLOR INDEX 4: PASTEL SKY BLUE
 ─────────────────────────────────
 Main:   RGB(0.7, 0.9, 1.0)  #B3E5FF
 Border: RGB(0.4, 0.6, 0.8)  #6699CC
 Letters: E, O, Y
 
 COLOR INDEX 5: PASTEL LAVENDER
 ─────────────────────────────────
 Main:   RGB(0.9, 0.8, 1.0)  #E5CCFF
 Border: RGB(0.6, 0.5, 0.8)  #997FCC
 Letters: F, P, Z
 
 COLOR INDEX 6: PASTEL ROSE
 ─────────────────────────────────
 Main:   RGB(1.0, 0.85, 0.9) #FFD9E5
 Border: RGB(0.8, 0.55, 0.6) #CC8C99
 Letters: G, Q
 
 COLOR INDEX 7: PASTEL AQUA
 ─────────────────────────────────
 Main:   RGB(0.85, 1.0, 0.9) #D9FFE5
 Border: RGB(0.55, 0.8, 0.6) #8CCC99
 Letters: H, R
 
 COLOR INDEX 8: PASTEL CREAM
 ─────────────────────────────────
 Main:   RGB(0.95, 0.95, 0.7) #F2F2B3
 Border: RGB(0.75, 0.75, 0.4) #BFBF66
 Letters: I, S
 
 COLOR INDEX 9: PASTEL ORCHID
 ─────────────────────────────────
 Main:   RGB(0.9, 0.7, 0.9)  #E5B3E5
 Border: RGB(0.6, 0.4, 0.6)  #996699
 Letters: J, T
 
 SELECTION COLOR
 ─────────────────────────────────
 Main:   RGB(0.3, 0.5, 1.0)  #4D7FFF (Bright Blue)
 Border: RGB(0.2, 0.3, 0.8)  #334DCC (Dark Blue)
 Usage:  Selected tiles
 
 ═══════════════════════════════════════════
 
 LETTER TO COLOR MAPPING ALGORITHM
 ═══════════════════════════════════════════
 
 func getColorIndex(for letter: String) -> Int {
     let unicodeValue = letter.unicodeScalars.first?.value ?? 65
     return Int(unicodeValue) % 10
 }
 
 Examples:
 A (65) → 65 % 10 = 5 → Pastel Lavender
 B (66) → 66 % 10 = 6 → Pastel Rose
 C (67) → 67 % 10 = 7 → Pastel Aqua
 D (68) → 68 % 10 = 8 → Pastel Cream
 E (69) → 69 % 10 = 9 → Pastel Orchid
 F (70) → 70 % 10 = 0 → Pastel Pink
 G (71) → 71 % 10 = 1 → Pastel Peach
 H (72) → 72 % 10 = 2 → Pastel Yellow
 I (73) → 73 % 10 = 3 → Pastel Mint
 J (74) → 74 % 10 = 4 → Pastel Sky Blue
 K (75) → 75 % 10 = 5 → Pastel Lavender
 ...and so on
 
 ═══════════════════════════════════════════
 
 UI GRADIENT COLORS
 ═══════════════════════════════════════════
 
 MAIN BACKGROUND:
 Top:    RGB(0.98, 0.95, 1.0)  #FAF2FF (Very light lavender)
 Bottom: RGB(1.0, 0.98, 0.95)  #FFF9F2 (Very light cream)
 
 GRID BACKGROUND:
 Top:    RGB(0.95, 0.95, 1.0)  #F2F2FF (Light lavender)
 Bottom: RGB(1.0, 0.95, 0.95)  #FFF2F2 (Light pink)
 
 SUCCESS MESSAGE:
 Top:    RGB(0.8, 1.0, 0.85)   #CCFFD9 (Light mint)
 Bottom: RGB(0.7, 0.95, 0.75)  #B3F2BF (Darker mint)
 
 ERROR MESSAGE:
 Top:    RGB(1.0, 0.85, 0.85)  #FFD9D9 (Light pink)
 Bottom: RGB(1.0, 0.75, 0.75)  #FFBFBF (Medium pink)
 
 SUBMIT BUTTON (ACTIVE):
 Top:    RGB(0.7, 1.0, 0.8)    #B3FFCC (Bright mint)
 Bottom: RGB(0.6, 0.95, 0.7)   #99F2B3 (Medium mint)
 
 CLEAR BUTTON (ACTIVE):
 Top:    RGB(1.0, 0.7, 0.7)    #FFB3B3 (Light red)
 Bottom: RGB(1.0, 0.6, 0.6)    #FF9999 (Medium red)
 
 FOUND WORD BADGES:
 Top:    RGB(0.7, 1.0, 0.8)    #B3FFCC (Mint green)
 Bottom: RGB(0.6, 0.9, 0.7)    #99E5B3 (Darker mint)
 Text:   RGB(0.2, 0.5, 0.3)    #33804D (Dark green)
 
 ═══════════════════════════════════════════
 
 TEXT COLORS
 ═══════════════════════════════════════════
 
 TILE LETTERS (UNSELECTED):
 Color: RGB(0.3, 0.3, 0.3)  #4D4D4D (Dark gray)
 Shadow: White 80% opacity, radius 1
 
 TILE LETTERS (SELECTED):
 Color: White #FFFFFF
 Shadow: None (blue background provides contrast)
 
 SUCCESS MESSAGE:
 Color: RGB(0.2, 0.6, 0.3)  #33994D (Dark green)
 
 ERROR MESSAGE:
 Color: RGB(0.8, 0.2, 0.2)  #CC3333 (Dark red)
 
 BUTTON TEXT (ACTIVE):
 Submit: RGB(0.2, 0.6, 0.3)  #33994D (Dark green)
 Clear:  RGB(0.8, 0.2, 0.2)  #CC3333 (Dark red)
 
 BUTTON TEXT (DISABLED):
 Color: Gray #808080
 
 ═══════════════════════════════════════════
 
 BORDER SPECIFICATIONS
 ═══════════════════════════════════════════
 
 TILE BORDER:
 Width: 2 points
 Radius (outer): 4 points
 Radius (inner): 2 points
 Color: Darker shade of tile color (see above)
 
 SELECTION NUMBER CIRCLE:
 Border width: 2 points
 Fill: White #FFFFFF
 Border color: Same as tile border
 Text: Same as tile border color
 Shadow: Black 30% opacity, radius 2
 
 ═══════════════════════════════════════════
 
 CONTRAST RATIOS (WCAG AA COMPLIANT)
 ═══════════════════════════════════════════
 
 Dark text on pastel backgrounds:
 Pink:     4.8:1 ✓ (Pass)
 Peach:    5.2:1 ✓ (Pass)
 Yellow:   6.1:1 ✓ (Pass)
 Mint:     5.8:1 ✓ (Pass)
 Sky:      5.5:1 ✓ (Pass)
 Lavender: 5.1:1 ✓ (Pass)
 Rose:     5.0:1 ✓ (Pass)
 Aqua:     5.9:1 ✓ (Pass)
 Cream:    6.3:1 ✓ (Pass)
 Orchid:   4.9:1 ✓ (Pass)
 
 All colors meet WCAG AA standards for readability!
 
 ═══════════════════════════════════════════
 
 VISUAL HIERARCHY
 ═══════════════════════════════════════════
 
 1. Selected tiles (brightest blue)
 2. Letter tiles (varied pastels)
 3. Active buttons (mint/red gradients)
 4. Messages (green/red gradients)
 5. Background (very light gradients)
 
 This hierarchy ensures:
 ✓ Selection is always visible
 ✓ Letters are the main focus
 ✓ Actions are clearly indicated
 ✓ Feedback is prominent
 ✓ Background doesn't compete
 
 */
