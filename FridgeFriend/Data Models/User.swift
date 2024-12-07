//
//  User.swift
//  FridgeFriend
//
//  Created by Ahaan Chaudhuri on 12/7/24.
//

// Data Model for User
struct User: Codable {
    let username: String
    let password: String
    var friends: [User] // List of friends (could be User IDs if needed)
    var fridges: [Fridge] // List of fridges the user belongs to
}
