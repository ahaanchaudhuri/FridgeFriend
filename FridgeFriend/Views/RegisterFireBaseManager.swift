//
//  RegisterFireBaseManager.swift
//  FridgeFriend
//
//  Created by Ahaan Chaudhuri on 12/8/24.
//

import Foundation
import FirebaseAuth

class RegisterFirebaseManager {

    /// Registers a new user with Firebase Authentication and sets the user's display name.
    ///
    /// - Parameters:
    ///   - name: The display name for the user.
    ///   - email: The user's email address.
    ///   - password: The user's password.
    ///   - completion: A closure that returns a result:
    ///                 `.success(Void)` on success, or `.failure(Error)` on failure.
    static func registerUser(name: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Handle error
                completion(.failure(error))
                return
            }

            // Set the user's display name
            guard let user = authResult?.user else {
                let unknownError = NSError(
                    domain: "com.fridgefriend.firebase",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "User creation succeeded, but no user object was returned."]
                )
                completion(.failure(unknownError))
                return
            }

            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
}
