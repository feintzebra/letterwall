//
//  DictionaryManager.swift
//  Letter Wall
//
//  Created by Joby on 01/04/2026.
//

import Foundation
import UIKit

/// Manages word validation using the system's UK English dictionary
@Observable
class DictionaryManager {
    static let shared = DictionaryManager()
    
    private let checker = UITextChecker()
    private let locale = Locale(identifier: "en_GB") // UK English
    
    // Comprehensive fallback word list for common words
    // Used if UITextChecker fails or on simulators with incomplete dictionaries
    private let fallbackWords: Set<String> = [
        // Common 4-letter words
        "able", "back", "ball", "band", "base", "beat", "best", "bird", "blue", "boat",
        "body", "book", "born", "both", "call", "came", "card", "care", "case", "cent",
        "city", "club", "cold", "come", "cool", "cost", "dark", "data", "date", "dead",
        "deal", "dear", "deep", "dine", "done", "door", "down", "draw", "drew", "drop",
        "drug", "each", "east", "easy", "edge", "else", "even", "ever", "face", "fact",
        "fail", "fair", "fall", "farm", "fast", "fear", "feel", "feet", "fell", "felt",
        "file", "fill", "film", "find", "fine", "fire", "firm", "fish", "five", "flat",
        "flow", "folk", "food", "foot", "form", "four", "free", "from", "full", "fund",
        "gain", "game", "gave", "girl", "give", "glad", "goal", "goes", "gold", "gone",
        "good", "gray", "grey", "grew", "grow", "hair", "half", "hall", "hand", "hang",
        "hard", "harm", "hate", "have", "head", "hear", "heat", "held", "help", "here",
        "hide", "high", "hill", "hold", "hole", "home", "hope", "host", "hour", "huge",
        "hung", "hurt", "idea", "into", "item", "join", "jump", "just", "keep", "kept",
        "kill", "kind", "king", "knee", "knew", "know", "lack", "lady", "laid", "lake",
        "land", "last", "late", "lead", "left", "less", "life", "lift", "like", "line",
        "link", "list", "live", "loan", "long", "look", "lord", "lose", "loss", "lost",
        "love", "made", "main", "make", "male", "many", "mark", "mass", "mate", "meal",
        "mean", "meet", "mere", "mile", "mill", "mind", "mine", "miss", "mode", "mood",
        "moon", "more", "most", "move", "much", "must", "name", "near", "neck", "need",
        "news", "next", "nice", "nine", "none", "nose", "note", "once", "only", "onto",
        "open", "oral", "over", "pace", "pack", "page", "paid", "pain", "pair", "pale",
        "park", "part", "pass", "past", "path", "peak", "pick", "pink", "plan", "play",
        "plot", "plus", "poem", "poet", "poll", "pool", "poor", "port", "post", "pull",
        "pure", "push", "race", "rain", "rang", "rank", "rare", "rate", "read", "real",
        "rear", "rely", "rent", "rest", "rice", "rich", "ride", "ring", "rise", "risk",
        "road", "rock", "role", "roll", "roof", "room", "root", "rope", "rose", "rule",
        "safe", "said", "sake", "sale", "salt", "same", "sand", "save", "seat", "seed",
        "seek", "seem", "seen", "self", "sell", "send", "sent", "ship", "shop", "shot",
        "show", "shut", "side", "sign", "sing", "site", "size", "skin", "slip", "slow",
        "soft", "soil", "sold", "sole", "some", "song", "soon", "sort", "soul", "spot",
        "star", "stay", "step", "stop", "such", "suit", "sure", "take", "tale", "talk",
        "tall", "tank", "tape", "task", "team", "tear", "teen", "tell", "tend", "term",
        "test", "text", "than", "that", "thee", "them", "then", "they", "thin", "this",
        "thus", "tide", "tied", "tile", "till", "time", "tiny", "told", "tone", "took",
        "tool", "torn", "tour", "town", "tree", "trip", "true", "tune", "turn", "twin",
        "type", "unit", "upon", "used", "user", "vary", "vast", "very", "view", "vote",
        "wage", "wait", "wake", "walk", "wall", "want", "warm", "warn", "wash", "wave",
        "ways", "weak", "wear", "week", "well", "went", "were", "west", "what", "when",
        "whom", "wide", "wife", "wild", "will", "wind", "wine", "wing", "wire", "wise",
        "wish", "with", "wood", "word", "wore", "work", "worn", "yard", "yeah", "year",
        "your", "zone", "sling",
        
        // Common 5-letter words
        "about", "above", "abuse", "actor", "acute", "admit", "adopt", "adult", "after",
        "again", "agent", "agree", "ahead", "alarm", "album", "alert", "align", "alike",
        "alive", "allow", "alone", "along", "alter", "angel", "anger", "angle", "angry",
        "apart", "apple", "apply", "arena", "argue", "arise", "array", "aside", "asset",
        "avoid", "award", "aware", "badly", "baker", "bases", "basic", "beach", "began",
        "begin", "being", "below", "bench", "billy", "birth", "black", "blade", "blame",
        "blind", "block", "blood", "board", "boost", "booth", "bound", "brain", "brand",
        "brass", "brave", "bread", "break", "breed", "brief", "bring", "broad", "broke",
        "brown", "build", "built", "buyer", "cable", "calif", "carry", "catch", "cause",
        "chain", "chair", "chart", "chase", "cheap", "check", "chest", "chief", "child",
        "china", "chose", "civil", "claim", "class", "clean", "clear", "click", "clock",
        "close", "cloth", "cloud", "coach", "coast", "could", "count", "court", "cover",
        "crack", "craft", "crash", "crazy", "cream", "crime", "cross", "crowd", "crown",
        "crude", "curve", "cycle", "daily", "dance", "dated", "dealt", "death", "debut",
        "delay", "depth", "doing", "doubt", "dozen", "draft", "drama", "drank", "drawn",
        "dream", "dress", "drill", "drink", "drive", "drove", "dying", "eager", "early",
        "earth", "eight", "elect", "empty", "enemy", "enjoy", "enter", "entry", "equal",
        "error", "event", "every", "exact", "exist", "extra", "faith", "false", "fault",
        "fence", "fiber", "field", "fifth", "fifty", "fight", "final", "first", "fixed",
        "flash", "fleet", "floor", "fluid", "focus", "force", "forth", "forty", "forum",
        "found", "frame", "frank", "fraud", "fresh", "front", "fruit", "fully", "funny",
        "giant", "given", "glass", "globe", "going", "grace", "grade", "grand", "grant",
        "grass", "great", "green", "gross", "group", "grown", "guard", "guess", "guest",
        "guide", "happy", "harry", "heart", "heavy", "hence", "henry", "horse", "hotel",
        "house", "human", "ideal", "image", "imply", "index", "inner", "input", "issue",
        "jimmy", "joint", "jones", "judge", "known", "label", "large", "laser", "later",
        "laugh", "layer", "learn", "lease", "least", "leave", "legal", "lemon", "level",
        "lewis", "light", "limit", "links", "lives", "local", "logic", "loose", "lower",
        "lucky", "lunch", "lying", "magic", "major", "maker", "march", "maria", "match",
        "maybe", "mayor", "meant", "media", "metal", "might", "minor", "minus", "mixed",
        "model", "money", "month", "moral", "motor", "mount", "mouse", "mouth", "moved",
        "movie", "music", "needs", "nerve", "never", "newly", "night", "noise", "north",
        "noted", "novel", "nurse", "occur", "ocean", "offer", "often", "order", "other",
        "ought", "outer", "owned", "owner", "paint", "panel", "paper", "paris", "party",
        "peace", "peter", "phase", "phone", "photo", "piano", "piece", "pilot", "pitch",
        "place", "plain", "plane", "plant", "plate", "point", "pound", "power", "press",
        "price", "pride", "prime", "print", "prior", "prize", "proof", "proud", "prove",
        "queen", "quick", "quiet", "quite", "radio", "raise", "range", "rapid", "ratio",
        "reach", "ready", "refer", "relax", "reply", "rider", "ridge", "rifle", "right",
        "rival", "river", "robin", "roger", "roman", "rough", "round", "route", "royal",
        "rural", "scale", "scene", "scope", "score", "sense", "serve", "seven", "shall",
        "shape", "share", "sharp", "sheet", "shelf", "shell", "shift", "shine", "shirt",
        "shock", "shoot", "short", "shown", "sight", "since", "sixth", "sixty", "sized",
        "skill", "sleep", "slide", "small", "smart", "smile", "smith", "smoke", "solid",
        "solve", "sorry", "sound", "south", "space", "spare", "speak", "speed", "spend",
        "spent", "split", "spoke", "sport", "staff", "stage", "stake", "stand", "start",
        "state", "steam", "steel", "stick", "still", "stock", "stone", "stood", "store",
        "storm", "story", "strip", "stuck", "study", "stuff", "style", "sugar", "suite",
        "super", "sweet", "table", "taken", "taste", "taxes", "teach", "teeth", "terry",
        "texas", "thank", "theft", "their", "theme", "there", "these", "thick", "thing",
        "think", "third", "those", "three", "threw", "throw", "tight", "times", "title",
        "today", "topic", "total", "touch", "tough", "tower", "track", "trade", "train",
        "treat", "trend", "trial", "tribe", "tried", "tries", "truck", "truly", "trust",
        "truth", "twice", "under", "undue", "union", "unity", "until", "upper", "upset",
        "urban", "usage", "usual", "valid", "value", "video", "virus", "visit", "vital",
        "vocal", "voice", "waste", "watch", "water", "wheel", "where", "which", "while",
        "white", "whole", "whose", "woman", "women", "world", "worry", "worse", "worst",
        "worth", "would", "wound", "write", "wrong", "wrote", "young", "youth",
        
        // UK spellings
        "colour", "favour", "honour", "labour", "neighbour", "rumour", "behaviour",
        "flavour", "harbour", "humour", "odour", "parlour", "analyse", "apologise",
        "authorise", "capitalise", "categorise", "characterise", "civilise", "criticise",
        "emphasise", "organise", "realise", "recognise", "specialise", "standardise",
        "summarise", "centre", "metre", "litre", "theatre", "fibre", "calibre",
        "defence", "licence", "offence", "pretence", "practise", "programme", "cheque"
    ]
    
    private init() {}
    
    /// Check if a word is valid in UK English dictionary
    /// - Parameter word: The word to validate (case insensitive)
    /// - Returns: True if the word exists in the dictionary
    func isValidWord(_ word: String) -> Bool {
        // Minimum length check
        guard word.count >= 3 else { 
            print("❌ Word '\(word)' too short (< 3)")
            return false 
        }
        
        let lowercasedWord = word.lowercased()
        let range = NSRange(location: 0, length: lowercasedWord.utf16.count)
        
        print("📖 Checking '\(lowercasedWord)' in UK dictionary...")
        
        // UITextChecker returns NSNotFound if word is valid
        let misspelledRange = checker.rangeOfMisspelledWord(
            in: lowercasedWord,
            range: range,
            startingAt: 0,
            wrap: false,
            language: "en_GB"
        )
        
        let isValid = misspelledRange.location == NSNotFound
        print("   UK Result: \(isValid ? "✓ Valid" : "✗ Invalid")")
        
        return isValid
    }
    
    /// Get suggestions for a misspelled word
    /// - Parameter word: The word to get suggestions for
    /// - Returns: Array of suggested corrections
    func getSuggestions(for word: String) -> [String] {
        let lowercasedWord = word.lowercased()
        let range = NSRange(location: 0, length: lowercasedWord.utf16.count)
        
        let guesses = checker.guesses(
            forWordRange: range,
            in: lowercasedWord,
            language: "en_GB"
        )
        
        return guesses ?? []
    }
    
    /// Check if a word exists in any English variant (fallback)
    /// - Parameter word: The word to validate
    /// - Returns: True if the word exists in any English dictionary
    func isValidInAnyEnglish(_ word: String) -> Bool {
        let variants = ["en_GB", "en_US", "en_AU", "en_CA"]
        let lowercasedWord = word.lowercased()
        let range = NSRange(location: 0, length: lowercasedWord.utf16.count)
        
        print("🌍 Checking '\(lowercasedWord)' across English variants...")
        
        for language in variants {
            let misspelledRange = checker.rangeOfMisspelledWord(
                in: lowercasedWord,
                range: range,
                startingAt: 0,
                wrap: false,
                language: language
            )
            
            if misspelledRange.location == NSNotFound {
                print("   ✓ Found in \(language)")
                return true
            } else {
                print("   ✗ Not in \(language)")
            }
        }
        
        print("   ❌ Not found in any variant")
        return false
    }
    
    /// Validate word with flexible rules
    /// - Parameters:
    ///   - word: The word to validate
    ///   - minLength: Minimum word length (default 3)
    ///   - allowProperNouns: Whether to allow proper nouns (default false)
    /// - Returns: True if word is valid
    func validateWord(
        _ word: String,
        minLength: Int = 3,
        allowProperNouns: Bool = false
    ) -> Bool {
        guard word.count >= minLength else { 
            print("❌ Word '\(word)' too short (minimum: \(minLength))")
            return false 
        }
        
        print("🔍 validateWord called with: '\(word)'")
        
        let lowercased = word.lowercased()
        
        // First check fallback list (guaranteed to work)
        if fallbackWords.contains(lowercased) {
            print("✅ Found in fallback word list")
            return true
        }
        
        // Then try any English variant for better acceptance
        if isValidInAnyEnglish(word) {
            print("✅ Accepted via multi-variant check")
            return true
        }
        
        // Fallback to UK English only
        let ukValid = isValidWord(word)
        if ukValid {
            print("✅ Accepted via UK dictionary")
        } else {
            print("❌ Rejected by all dictionaries")
        }
        
        return ukValid
    }
}

// MARK: - Alternative Dictionary Implementation (Optional)
/// For offline/custom dictionary support if needed
class OfflineDictionary {
    static let shared = OfflineDictionary()
    
    // Common UK spelling variants that might be missed
    private let ukSpecificWords: Set<String> = [
        "colour", "favour", "honour", "labour", "neighbour", "rumour",
        "behaviour", "flavour", "harbour", "humour", "odour", "parlour",
        "analyse", "apologise", "authorise", "capitalise", "categorise",
        "characterise", "civilise", "criticise", "emphasise", "organise",
        "realise", "recognise", "specialise", "standardise", "summarise",
        "centre", "metre", "litre", "theatre", "fibre", "calibre",
        "defence", "licence", "offence", "pretence", "practise",
        "grey", "cheque", "programme", "tyre", "kerb", "storey"
    ]
    
    private init() {}
    
    /// Check if word is a known UK-specific spelling
    func isUKWord(_ word: String) -> Bool {
        ukSpecificWords.contains(word.lowercased())
    }
}
