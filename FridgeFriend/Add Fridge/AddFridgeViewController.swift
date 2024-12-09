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
    let addFridge = AddFridgeView()
    var currentUser:FirebaseAuth.User?
    
    override func loadView() {
        view = addFridge
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFridge.submitButton.addTarget(self, action: #selector(onSubmitButtonTapped), for: .touchUpInside)
    }
    
    // when the submit button is tapped.
    @objc func onSubmitButtonTapped() {
        
        if let uwFridgeName = addFridge.fridgeNameTextField.text, !uwFridgeName.isEmpty {
            // create the firestore fridge.
            print("The current user is: ",currentUser)
            if let uwUserEmail = currentUser?.email {
                let newFridge = Fridge(name: uwFridgeName, members: [uwUserEmail], items: [])
                print("saving fridge to firestore", newFridge)
                saveFridgeToFireStore(fridge: newFridge)
            } else {
                print("Invalid user email")
            }
        } else {
            print("Add an alert to let the user know that the fridge name is invalid.")
        }
        
    }
    
    
    let database = Firestore.firestore()
    
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
                    
                })}
            catch{
                print("Error adding document!")
            }
        }
    }
}
