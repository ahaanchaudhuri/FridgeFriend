//
//  User.swift
//  FridgeFriend
//
//  Created by Ahaan Chaudhuri on 12/7/24.
//

// Data Model for User
struct User: Codable {
    let email: String
    let uid: String
    let name: String
    
    // Init for the user - there is no password being stored, just a user ID.
    init( email: String, uid: String, name: String) {
        self.uid = uid
        self.name = name
        self.email = email
    }
}
