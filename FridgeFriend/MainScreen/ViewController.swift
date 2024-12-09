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
        handleAuth = Auth.auth().addStateDidChangeListener { auth, user in
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
    
    func getAllFridges() async {
        let fridgesRef = database.collection("users")
            .document((self.currentUser?.email)!).collection("fridges")
        
        do {
            let querySnapshot = try await fridgesRef.getDocuments()
            var fridges: [Fridge] = []
            
            for document in querySnapshot.documents {
                var fridge = try document.data(as: Fridge.self)
                fridge.id = document.documentID // Add the document ID if needed
                fridges.append(fridge)
            }
            
            print("The final fridges list is:", fridges)
        } catch {
            print("Error fetching fridges: \(error.localizedDescription)")
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
        let fridgeName = fridgesList[indexPath.row].name
        
        let v = FridgeViewController()
        v.fridge = fridgesList[indexPath.row]
        v.currentUser = self.currentUser
        
        navigationController?.pushViewController(v, animated: true)
    }
}

