//
//  Item.swift
//  Letter Wall
//
//  Created by Joby on 01/04/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
