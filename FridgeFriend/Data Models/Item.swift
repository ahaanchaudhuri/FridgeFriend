//
//  Item.swift
//  App10
//
//  Created by Ahaan Chaudhuri on 12/7/24.
//

import Foundation

// Data Model for Item
struct Item: Codable {
    var id: String? // Item id.
    let name: String // Name of the item
    let category: String // Category of the item (e.g., dairy, meats)
    let photo: String // URL or Base64 string for the item's photo
    let dateAdded: Date // The date the item was added
    let memberName: String // Name of the member who added the item
    
    init(name: String, category: String, photo: String, dateAdded: Date, memberName: String) {
        self.name = name
        self.category = category
        self.photo = photo
        self.dateAdded = dateAdded
        self.memberName = memberName
    }
}
