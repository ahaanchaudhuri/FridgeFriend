//
//  RightBarButtonManager.swift
//  FridgeFriend
//
//  Created by Rohil Doshi on 12/8/24.
//


import UIKit
import FirebaseAuth

extension ViewController{
    func setupRightBarButton(isLoggedin: Bool){
        if isLoggedin{
            //MARK: user is logged in...
            let barIcon = UIBarButtonItem(
                image: UIImage(systemName: "rectangle.portrait.and.arrow.forward"),
                style: .plain,
                target: self,
                action: #selector(onLogOutBarButtonTapped)
            )
            let barText = UIBarButtonItem(
                title: "Logout",
                style: .plain,
                target: self,
                action: #selector(onLogOutBarButtonTapped)
            )
            
            navigationItem.rightBarButtonItems = [barIcon, barText]
            
        }else{
            //MARK: not logged in...
            let barIcon = UIBarButtonItem(
                image: UIImage(systemName: "person.fill.questionmark"),
                style: .plain,
                target: self,
                action: #selector(onSignInBarButtonTapped)
            )
            let barText = UIBarButtonItem(
                title: "Sign in",
                style: .plain,
                target: self,
                action: #selector(onSignInBarButtonTapped)
            )
            
            navigationItem.rightBarButtonItems = [barIcon, barText]
        }
    }
    
    // If the sign in button is tapped,
    @objc func onSignInBarButtonTapped(){
        // create an alert that says sign in
        let signInAlert = UIAlertController(
            title: "Sign In / Register",
            message: "Please sign in to continue.",
            preferredStyle: .alert)
        
        // Add textfields to the alert:
        // Email / Username
        signInAlert.addTextField{ textField in
            textField.placeholder = "Enter email"
            textField.contentMode = .center
            textField.keyboardType = .emailAddress
        }
        
        // Password
        signInAlert.addTextField{ textField in
            textField.placeholder = "Enter password"
            textField.contentMode = .center
            textField.isSecureTextEntry = true
        }
        
        // If the user presses sign in
        let signInAction = UIAlertAction(title: "Sign In", style: .default, handler: {(_) in
            if let email = signInAlert.textFields![0].text,
               let password = signInAlert.textFields![1].text{
                print(email, password)
            }
        })
        
        // If the user presses register
        let registerAction = UIAlertAction(title: "Register", style: .default, handler: {(_) in
            // Navigate to the register screen
            let registerViewController = RegisterViewController()
            self.navigationController?.pushViewController(registerViewController, animated: true)
        })
        
        // Add two buttons to the alert that say sign in and register
        signInAlert.addAction(signInAction)
        signInAlert.addAction(registerAction)
        
        // Present the alert to the suer.
        self.present(signInAlert, animated: true, completion: {() in
            // Hide the alert on tap outside.
            signInAlert.view.superview?.isUserInteractionEnabled = true
            signInAlert.view.superview?.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(self.onTapOutsideAlert))
            )
        })
    }
    
    // If the user taps outside, dismiss the alert.
    @objc func onTapOutsideAlert(){
        self.dismiss(animated: true)
    }
    
    // If the user is logged in and presses the log out button.
    @objc func onLogOutBarButtonTapped(){
        // Ask the user if they are sure that they want to log out.
        let logoutAlert = UIAlertController(title: "Logging out!", message: "Are you sure want to log out?",
            preferredStyle: .actionSheet)
        
        // Call the firebase sign out method.
        logoutAlert.addAction(UIAlertAction(title: "Yes, log out!", style: .default, handler: {(_) in
                do{
                    try Auth.auth().signOut()
                }catch{
                    print("Error occured!")
                }
            })
        )
        
        // Add a cancel button for the user.
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // Present the alert to the user.
        self.present(logoutAlert, animated: true)
    }
    
}
