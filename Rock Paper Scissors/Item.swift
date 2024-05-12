//
//  Item.swift
//  Rock Paper Scissors
//
//  Created by Vincent Leong on 12/5/2024.
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
