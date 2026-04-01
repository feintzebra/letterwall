//
//  QUICK_REFERENCE.md
//  Letter Wall - Quick Reference Card
//

# 🎮 Letter Wall - Quick Reference

## 🎯 Game Rules
- **Minimum Word Length**: 4 letters
- **Word Validation**: UK English Dictionary
- **Tile Connection**: Adjacent or diagonal
- **Scoring**: 10 points per letter

## 🇬🇧 UK Spellings (These Work!)
```
✅ colour   ✅ centre    ✅ realise
✅ favour   ✅ metre     ✅ organise  
✅ honour   ✅ litre     ✅ defence
✅ grey     ✅ theatre   ✅ cheque
```

## 📝 Example 4-Letter Words
```
ABLE  BACK  CALL  DARK  EACH  FACE  GOOD  HAND
HELP  INTO  JUST  KEEP  LAST  MADE  NAME  ONLY
PART  REAL  SIDE  TAKE  USED  VERY  WANT  YEAR
```

## 🎨 Visual Feedback

| State | Visual | Meaning |
|-------|--------|---------|
| Gray Button | 🔘 | Need more letters |
| Green Button | 🟢 | Ready to submit |
| ✓ Green Badge | Success! | Valid word found |
| ✗ Red Badge | Error | Not in dictionary |
| Orange Text | Warning | "Need X more letters" |
| Blue Highlight | Selected | Tile in current word |
| Numbers (1,2,3) | Order | Selection sequence |

## 🎬 Animations

**When you submit a valid word:**
1. ⚡ Selected tiles **explode** (scale + rotate + fade)
2. 🎢 Remaining tiles **drop down** with physics
3. 🌧️ New tiles **rain in** from top
4. 💫 Each column **cascades** independently

## 🎯 Strategy Tips

### High-Scoring Words:
- **4 letters** = 40 points (WORD, MAKE, TAKE)
- **5 letters** = 50 points (GREAT, HOUSE, WORLD)
- **6 letters** = 60 points (COLOUR, FRIEND, BEFORE)
- **7 letters** = 70 points (BECAUSE, EXAMPLE, THROUGH)

### Letter Patterns to Look For:
```
-ING words: RING, SING, WING, KING, BRING, THING
-TION words: (too long usually, need MOTION, NATION)
-ED words: AGED, USED, NEED, BASED, MOVED
-ER words: EVER, OVER, UNDER, WATER, BETTER
Double letters: BOOK, LOOK, GOOD, KEEP, FEEL, TELL
```

## 🔧 Customization Locations

Want to change the game? Here's where to look:

### Minimum Word Length
**File**: `GameBoard.swift` line ~94
```swift
guard word.count >= 4  // Change this number
```

**File**: `GameView.swift` line ~189
```swift
.disabled(gameBoard.currentWord.count < 4)  // Change this number
```

### Dictionary Locale
**File**: `DictionaryManager.swift` line ~20
```swift
private let locale = Locale(identifier: "en_GB")  // Change to "en_US" etc.
```

### Scoring System
**File**: `GameBoard.swift` line ~113
```swift
return word.count * 10  // Change multiplier or add bonuses
```

### Animation Timing
**File**: `GameBoard.swift`:
- Line ~118: Removal delay (300ms)
- Line ~154: Column cascade (50ms)
- Line ~158: Animation wait (600ms)

**File**: `GameView.swift` (LetterTileView):
- Scale: 1.5 (removal size)
- Rotation: 180° (removal spin)
- Response: 0.6-0.8 (spring speed)
- Damping: 0.5-0.6 (bounce amount)

### Grid Size
**File**: `GameBoard.swift` line ~30
```swift
init(rows: Int = 8, columns: Int = 6)  // Change default size
```

## 🐛 Troubleshooting

### "Invalid Word" for common words?
- Check if word is 4+ letters
- Verify UK spelling (colour not color)
- Try capitalizing differently (should work anyway)
- Check if it's a proper noun (not accepted)

### Animations too fast/slow?
- Adjust spring response values (higher = slower)
- Change damping values (lower = more bounce)
- Modify delay timers in GameBoard

### Want to accept 3-letter words?
- Change all instances of `4` to `3` in validation code
- Update both GameBoard and GameView

### Want US spellings?
- Change locale to "en_US" in DictionaryManager
- Or use `isValidInAnyEnglish()` method

## 📚 Documentation Files

- **CHANGES_SUMMARY.md** - All changes made
- **DICTIONARY_README.md** - Dictionary system docs
- **ValidWordsExamples.swift** - Example valid words
- **AnimationGuide.swift** - Animation system details
- **DictionaryTests.swift** - Test suite

## 🎓 Learning Resources

### Test the Dictionary:
```swift
let dict = DictionaryManager.shared

// Check a word
dict.isValidWord("colour")  // true

// Get suggestions  
dict.getSuggestions(for: "teh")  // ["the", "tea", "ten"]

// Custom validation
dict.validateWord("cats", minLength: 4, allowProperNouns: false)
```

### Experiment with Animations:
1. Change `scale = 1.5` to `2.0` for bigger explosions
2. Change `rotationAngle = 180` to `360` for full spins
3. Adjust delay values for faster/slower cascades
4. Try different spring damping values

## 🚀 Quick Start

1. **Run the app**
2. **Tap 4+ adjacent letters**
3. **Hit Submit (green button)**
4. **Watch the animations!**
5. **Try UK words like COLOUR, CENTRE, GREY**

## 💡 Pro Tips

- Plan ahead for longer words (more points!)
- Look for vowel-rich areas (more word options)
- UK spellings often have more letters (COLOUR > COLOR)
- Diagonal connections give more flexibility
- Watch how tiles fall to plan next word
- Recent words shown at bottom (learn patterns)

---

**Have fun! Happy word hunting! 🎉**
