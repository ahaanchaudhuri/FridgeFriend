//
//  LoginFireBaseManager.swift
//  FridgeFriend
//
//  Created by Ahaan Chaudhuri on 12/8/24.
//

import Foundation
import FirebaseAuth

class LoginFirebaseManager {
    
    /// Logs in a user with the provided email and password using Firebase Authentication.
    ///
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    ///   - completion: A closure that is called when the login is complete.
    ///                 On success, the closure returns `.success(Void)`.
    ///                 On failure, it returns `.failure(Error)`.
    static func loginUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Return failure with the error
                completion(.failure(error))
            } else if authResult?.user != nil {
                // Return success
                completion(.success(()))
            } else {
                // Handle unexpected case where no error or user is returned
                let unknownError = NSError(
                    domain: "com.fridgefriend.firebase",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "An unknown error occurred during login."]
                )
                completion(.failure(unknownError))
            }
        }
    }
}
