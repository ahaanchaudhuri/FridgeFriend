//
//  ViewController.swift
//  FridgeFriend
//
//  Created by Ahaan Chaudhuri on 12/7/24.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    // Fire base authentication handling
    var handleAuth: AuthStateDidChangeListenerHandle?
    var currentUser:FirebaseAuth.User?
    
    let mainScreen = MainView()
    
    // List of fridges
    var fridgesList = [Fridge]()
    
    
    override func loadView() {
        view = mainScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Fridges"
        
        mainScreen.tableViewFridges.delegate = self
        mainScreen.tableViewFridges.dataSource = self
        mainScreen.tableViewFridges.separatorStyle = .none
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.bringSubviewToFront(mainScreen.floatingButtonAddFridge)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: handling if the Authentication state is changed (sign in, sign out, register)...
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
            if user == nil{
                // If the user is not signed in:
                self.currentUser = nil
                self.mainScreen.labelText.text = "Please sign in to see the Fridges!"
                self.mainScreen.floatingButtonAddFridge.isEnabled = false
                self.mainScreen.floatingButtonAddFridge.isHidden = true
                
                // There are no fridges in the list
                self.fridgesList.removeAll()
                self.mainScreen.tableViewFridges.reloadData()
                
                self.setupRightBarButton(isLoggedin: false)
                
            }else{
                // If the user is signed in
                self.currentUser = user
                self.mainScreen.labelText.text = "Welcome \(user?.displayName ?? "Anonymous")!"
                self.mainScreen.floatingButtonAddFridge.isEnabled = true
                self.mainScreen.floatingButtonAddFridge.isHidden = false
                
                self.setupRightBarButton(isLoggedin: true)
            }
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handleAuth!)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fridgesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.fridgeViewContactsID, for: indexPath) as! FridgesTableViewCell
        cell.labelName.text = fridgesList[indexPath.row].name
        // map all the members names
        cell.labelMembers.text = fridgesList[indexPath.row].members.map { $0.username }.joined(separator: ", ")
        return cell
    }
}

