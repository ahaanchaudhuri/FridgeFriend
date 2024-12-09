//
//  ViewController.swift
//  FridgeFriend
//
//  Created by Ahaan Chaudhuri on 12/7/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {
    
    // Fire base authentication handling
    var handleAuth: AuthStateDidChangeListenerHandle?
    var currentUser:FirebaseAuth.User?
    
    let mainScreen = MainView()
    
    // List of fridges
    var fridgesList = [Fridge]()
    
    let database = Firestore.firestore()
    
    
    override func loadView() {
        view = mainScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Fridges"
        
        mainScreen.tableViewFridges.delegate = self
        mainScreen.tableViewFridges.dataSource = self
        mainScreen.tableViewFridges.separatorStyle = .none
        
        mainScreen.floatingButtonAddFridge.addTarget(self, action: #selector(onAddFridgeTapped), for: .touchUpInside)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.bringSubviewToFront(mainScreen.floatingButtonAddFridge)
    }
    
    @objc func onAddFridgeTapped(){
        let fViewController = AddFridgeViewController()
        fViewController.currentUser = self.currentUser
        navigationController?.pushViewController(fViewController, animated: true)
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
                
                
                // MARK: Observe Firestore database to display the contacts list...
                self.database.collection("users")
                    .document((self.currentUser?.email)!)
                    .collection("fridges")
                    .addSnapshotListener(includeMetadataChanges: false, listener: {querySnapshot, error in
                        if let documents = querySnapshot?.documents{
                            self.fridgesList.removeAll()
                            for document in documents{
                                do{
                                    var Fridge = try document.data(as: Fridge.self)
                                    Fridge.id = document.documentID
                                    self.fridgesList.append(Fridge)
                                }catch{
                                    print(error)
                                }
                            }
                            self.fridgesList.sort(by: {$0.name < $1.name})
                            self.mainScreen.tableViewFridges.reloadData()
                        }
                    })
            }
        }
    }
    
    func getAllMemberNames (fridgeId: String) {
        
        print("Entered get all members with fridge id", fridgeId)
        let fridgeRef = database.collection("fridges").document(fridgeId)
                
        fridgeRef.getDocument { (fridgeSnapshot, error) in
            if let error = error {
                print("Error fetching fridge document: \(error)")
                return
            }
            
            
            guard let fridgeData = fridgeSnapshot?.data(),
                  let memberIds = fridgeData["members"] as? [String] else {
                print("Fridge document does not exist or is missing 'members'", fridgeSnapshot?.data())
                return
            }
            
            let usersCollection = self.database.collection("users")
            var userNames: [String] = []
            
            for userId in memberIds {
                let userRef = usersCollection.document(userId)
                userRef.getDocument { (userSnapshot, error) in
                    if let error = error {
                        print("Error fetching user document for \(userId): \(error)")
                    }

                    if let userData = userSnapshot?.data(), let userName = userData["username"] as? String {
                        userNames.append(userName)
                    } else {
                        print("User document not found or missing 'name' for userId: \(userId)")
                    }
                }
            }
            
            print("The members of this fridge are:", userNames)
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let uwFridgeID = fridgesList[indexPath.row].id {
            getAllMemberNames(fridgeId: uwFridgeID)
        } else {
            print("No fridge id found")
        }
    }
}

