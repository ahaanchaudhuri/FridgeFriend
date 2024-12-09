//
//  Fridge.swift
//  FridgeFriend
//
//  Created by Ahaan Chaudhuri on 12/7/24.
//


// Data Model for Fridge
struct Fridge: Codable {
    let name: String // Name of the fridge
    var members: [User] // List of users who are members of the fridge
    var items: [Item] // List of items in the fridge
    
    init(name: String, members: [User], items: [Item]) {
        self.name = name
        self.members = members
        self.items = items
    }
}
