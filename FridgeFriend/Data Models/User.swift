//
//  User.swift
//  FridgeFriend
//
//  Created by Ahaan Chaudhuri on 12/7/24.
//

// Data Model for User
struct User: Codable {
    let uid: String
    let username: String
    var friends: [User] // List of friends (could be User IDs if needed)
    var fridges: [Fridge] // List of fridges the user belongs to
    
    // Init for the user - there is no password being stored, just a user ID.
    init(uid: String, username: String, friends: [User], fridges: [Fridge]) {
        self.uid = uid
        self.username = username
        self.friends = friends
        self.fridges = fridges
    }
}
