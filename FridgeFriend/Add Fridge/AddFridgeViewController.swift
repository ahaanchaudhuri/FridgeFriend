//
//  AddFridgeViewController.swift
//  FridgeFriend
//
//  Created by Rohil Doshi on 12/9/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AddFridgeViewController: UIViewController {

    // setting up the view
    let addFridge = AddFridgeView()
    // user authentication
    var currentUser:FirebaseAuth.User?
    
    // firestore database
    let database = Firestore.firestore()
    
    // the list of users for the picker
    var users: [User] = []
    // the selected user from the pickers
    var selectedUser: User!
    
    override func loadView() {
        view = addFridge
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFridge.submitButton.addTarget(self, action: #selector(onSubmitButtonTapped), for: .touchUpInside)
        
        Task {
            await getAllUsers()
        }
    }
        
    // when the submit button is tapped.
    @objc func onSubmitButtonTapped() {
        
        if let uwFridgeName = addFridge.fridgeNameTextField.text, !uwFridgeName.isEmpty {
            // create the firestore fridge.
            if let uwUserEmail = currentUser?.email {
                let newFridge = Fridge(name: uwFridgeName, members: [uwUserEmail], items: [])
                saveFridgeToFireStore(fridge: newFridge)
            } else {
                print("Invalid user email")
            }
        } else {
            print("Add an alert to let the user know that the fridge name is invalid.")
        }
        
    }
        
    func saveFridgeToFireStore(fridge: Fridge){
        if let userEmail = currentUser!.email{
            let collectionFridges = database
                            .collection("users")
                            .document(userEmail)
                            .collection("fridges")
            do{
                let newFridge = try collectionFridges.addDocument(from: fridge, completion: {(error) in
                    if error == nil{
                        self.navigationController?.popViewController(animated: true)
                    }
                })
                print("New fridge added with path: ", newFridge.path)
            }
            catch{
                print("Error adding document!")
            }
        }
    }
    
    func getAllUsers() async {
        // have to figure out how to get all the users
        let usersRef = database.collection("user-list")
        
        do {
            let querySnapshot = try await usersRef.getDocuments()
                        
            for document in querySnapshot.documents {
                let newUser: User = try document.data(as: User.self)
                users.append(newUser)
            }
        } catch {
            print("Error fetching users: \(error.localizedDescription)")
        }
    }
    
}
