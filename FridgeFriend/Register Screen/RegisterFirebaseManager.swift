//
//  RegisterFirebaseManager.swift
//  FridgeFriend
//
//  Created by Rohil Doshi on 12/8/24.
//

import Foundation
import FirebaseAuth

extension RegisterViewController{
    
    func registerNewAccount(){
        print("Entered register account")
        print("Name text field", registerView.textFieldName.text)
        print("Email text field", registerView.textFieldEmail.text)
        print("Password text field", registerView.textFieldPassword.text)
        // create a Firebase user with email and password.
        if let name = registerView.textFieldName.text,
           let email = registerView.textFieldEmail.text,
           let password = registerView.textFieldPassword.text{
            //Validations....
            Auth.auth().createUser(withEmail: email, password: password, completion: {result, error in
                if error == nil{
                    //MARK: the user creation is successful...
                    self.setNameOfTheUserInFirebaseAuth(name: name)
                    print("User registered, name", name, email, password)
                }else{
                    // MARK: there is a error creating the user...
                    print(error ?? "Default error")
                }
            })
        }
    }
    
    // We set the name of the user after we create the account...
    func setNameOfTheUserInFirebaseAuth(name: String){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges(completion: {(error) in
            if error == nil{
                //MARK: the profile update is successful...
                self.navigationController?.popViewController(animated: true)
            }else{
                //MARK: there was an error updating the profile...
                print("Error occured: \(String(describing: error))")
            }
        })
    }
}
