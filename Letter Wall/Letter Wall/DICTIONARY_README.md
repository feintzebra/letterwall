# Letter Wall - UK English Dictionary Integration

## Overview

The game now validates all words against the **UK English dictionary** using iOS's built-in `UITextChecker` API. This provides comprehensive, system-level dictionary validation without requiring any external files or APIs.

## Features

### ✅ What's Validated

- **Minimum Length**: 4 letters or more
- **Dictionary**: Full UK English dictionary (en_GB locale)
- **Case Insensitive**: WORD, Word, word all work
- **Real-time Feedback**: Instant validation when submitting
- **Spelling Suggestions**: Get suggestions for misspelled words

### 🇬🇧 UK English Support

The dictionary specifically uses UK spellings:
- ✅ `colour` (not color)
- ✅ `favour` (not favor)
- ✅ `centre` (not center)
- ✅ `realise` (not realize)
- ✅ `defence` (not defense)
- ✅ `grey` (not gray)

### 📝 Example Valid Words

4-letter words:
- word, have, make, time, year, back, call, came, come, find, give, hand, high, just, know, last, like, line, live, long, look, made, many, more, most, move, much, must, name, need, only, over, part, play, said, same, show, such, take, tell, than, that, them, then, they, this, very, want, well, went, were, what, when, with

5+ letter words:
- house, great, think, about, after, again, could, every, first, found, going, leave, might, never, other, place, right, small, sound, spell, still, study, their, there, these, thing, think, three, water, where, which, while, world, would, write, years

## How It Works

### DictionaryManager

The `DictionaryManager` class provides:

```swift
// Check if a word is valid
dictionary.isValidWord("colour") // true

// Validate with custom rules
dictionary.validateWord("word", minLength: 4, allowProperNouns: false)

// Get spelling suggestions
dictionary.getSuggestions(for: "teh") // ["the", "tea", "ten"]

// Check multiple English variants
dictionary.isValidInAnyEnglish("color") // true (US spelling)
```

### GameBoard Integration

Words are validated in the `submitWord()` function:

1. User selects tiles to form a word
2. Word must be 4+ letters
3. Word is checked against UK English dictionary
4. Valid words score points and trigger animations
5. Invalid words show error message with suggestions

## User Interface

### Visual Feedback

- **Character Counter**: Shows "Need X more letters" when < 4 letters
- **Valid Word**: Green checkmark ✓ and success animation
- **Invalid Word**: Red X ✗ with message "Not in Dictionary"
- **Suggestions**: Shows up to 2 spelling suggestions for invalid words
- **Submit Button**: 
  - Gray when < 4 letters (disabled)
  - Green when 4+ letters (active)

### Recent Words Display

- Shows last 5 found words
- Scrollable horizontal list
- Green badges with word text

## Performance

- ⚡ **Native API**: Uses iOS system dictionary (no downloads)
- 🚀 **Fast Validation**: Instant checks via UITextChecker
- 💾 **No Storage**: No dictionary files to bundle
- 🌐 **Always Updated**: Uses system's current dictionary

## Testing

Run the test suite (`DictionaryTests.swift`) to verify:
- Valid UK words are accepted
- Invalid words are rejected
- Short words are rejected
- Case insensitivity works
- Suggestions are provided

```swift
import Testing

@Test("Valid UK English words are accepted")
func testValidWords() {
    #expect(dictionary.isValidWord("colour"))
    #expect(dictionary.isValidWord("centre"))
}
```

## Customization

### Adjust Minimum Length

In `GameBoard.swift` and `GameView.swift`:
```swift
// Change from 4 to any number
guard word.count >= 4 else { ... }
```

### Allow Proper Nouns

In `DictionaryManager.swift`:
```swift
dictionary.validateWord(word, minLength: 4, allowProperNouns: true)
```

### Change Dictionary Locale

In `DictionaryManager.swift`:
```swift
private let locale = Locale(identifier: "en_US") // For US English
private let locale = Locale(identifier: "en_AU") // For Australian English
```

## Known Limitations

1. **System Dependent**: Dictionary contents vary by iOS version
2. **Common Words Only**: Very obscure words might not be recognized
3. **No Custom Words**: Can't add custom words to system dictionary
4. **No Offline Indicator**: Works offline (system dictionary is local)

## Future Enhancements

Potential additions:
- [ ] Custom word list supplement
- [ ] Scrabble/word game scoring (letter values)
- [ ] Word definitions on long-press
- [ ] Multiple language support
- [ ] Word length bonus scoring
- [ ] Difficulty levels (rare vs common words)
- [ ] Daily challenge words

## Technical Details

**Framework**: UIKit's UITextChecker
**Locale**: en_GB (British English)
**Validation Method**: `rangeOfMisspelledWord` (NSNotFound = valid)
**Minimum iOS**: iOS 13.0+
**Thread Safe**: Yes (uses MainActor where needed)
