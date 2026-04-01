//
//  AnimationGuide.swift
//  Letter Wall
//
//  Animation System Documentation
//

/*
 ENHANCED ANIMATION SYSTEM
 =========================
 
 The game now features three distinct animation types:
 
 1. REMOVING ANIMATION
    - Triggered when a valid word is submitted
    - Tiles scale up to 1.5x size
    - Rotate 180° in 3D space
    - Fade out over 300ms
    - Creates a "popping" effect
 
 2. DROPPING ANIMATION
    - Triggered when existing tiles fall into gaps
    - Duration scales with drop distance (longer falls = longer animation)
    - 3D rotation based on distance (90° per row)
    - Spring animation with bounce effect
    - Response time: 0.6s + 0.05s per row dropped
    - Damping: 0.6 for realistic physics
 
 3. SPAWNING ANIMATION
    - Triggered when new tiles appear from top
    - Tiles start at 0.5x scale, 0 opacity, -180° rotation
    - Cascade effect with 50ms delay per column
    - Spring animation brings them to normal state
    - Response time: 0.7-0.8s with damping 0.5-0.6
    - Each column delays by 50ms for wave effect
 
 TIMING SEQUENCE
 ===============
 
 When a word is submitted:
 1. Selected tiles pop out (300ms)
 2. Tiles are removed from grid
 3. Column-by-column processing (50ms stagger)
 4. Existing tiles drop with physics (600ms)
 5. New tiles spawn from above (700ms)
 6. All animations cleared after completion
 
 CUSTOMIZATION OPTIONS
 =====================
 
 In GameBoard.swift:
 - Removal wait time: 300ms (line ~110)
 - Column cascade delay: 50ms (line ~154)
 - Final wait time: 600ms (line ~158)
 
 In LetterTileView.swift:
 - Removal scale: 1.5 (can increase for more dramatic)
 - Removal rotation: 180° (try 360° for full spin)
 - Drop response: 0.6 base + 0.05 per row
 - Drop damping: 0.6 (lower = more bounce)
 - Spawn response: 0.7-0.8 (higher = slower)
 - Spawn rotation: -180° (try different angles)
 - Column spawn delay: 50ms (for cascade timing)
 
 PERFORMANCE NOTES
 =================
 
 - All animations use SwiftUI's native animation system
 - @Observable macro ensures efficient state updates
 - Animations are hardware accelerated
 - Spring physics calculated by Metal/Core Animation
 - No manual timing loops or DispatchQueue needed
 
 VISUAL EFFECTS
 ==============
 
 Each tile features:
 - Linear gradient (top-left to bottom-right)
 - Dynamic shadow (blue when selected, black otherwise)
 - 3D rotation on all three axes during animations
 - Scale transformations for emphasis
 - Opacity transitions for smooth appear/disappear
 
 The combination creates a physics-based feel where:
 - Removed tiles "explode" away
 - Falling tiles tumble realistically
 - New tiles "rain" down from above
 - Each column moves independently for cascading effect
 */
