//
//  FridgeViewController.swift
//  FridgeFriend
//
//  Created by Ahaan Chaudhuri on 12/7/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FridgeViewController: UIViewController {
    var currentUser:FirebaseAuth.User?
    
    // UI Components
    private let fridgeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let tableView = UITableView()
    private let addItemButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Item", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var fridge: Fridge!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        // Add Subviews
        view.addSubview(fridgeNameLabel)
        view.addSubview(tableView)
        view.addSubview(addItemButton)

        // Configure Fridge Name Label
        fridgeNameLabel.text = fridge.name

        // Configure TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "itemCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        // Add Target
        addItemButton.addTarget(self, action: #selector(addItemTapped), for: .touchUpInside)

        // Set Constraints
        setConstraints()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            fridgeNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            fridgeNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            fridgeNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: fridgeNameLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addItemButton.topAnchor, constant: -16),

            addItemButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addItemButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addItemButton.widthAnchor.constraint(equalToConstant: 120),
            addItemButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func addItemTapped() {
        let addItemVC = AddItemViewController()
        addItemVC.currentUser = self.currentUser
        addItemVC.currentFridge = self.fridge
        navigationController?.pushViewController(addItemVC, animated: true)
    }
    
    func deleteItemFromFridge(item: Item) async {
        let database = Firestore.firestore()
        
        let itemData: [String: Any] = [
            "name": item.name,
            "category": item.category,
            "photo": item.photo,
            "dateAdded": Timestamp(date: item.dateAdded),
            "memberName": item.memberName
        ]
        
        let fridgesRef = database.collection("users")
            .document((self.currentUser?.email)!).collection("fridges")
            .document((self.fridge?.id)!)
        
        do {
            try await fridgesRef.updateData(["items": FieldValue.arrayRemove([itemData])])
        } catch {
            print("Error adding item to fridge: \(error.localizedDescription)")
        }
    }
    
}

// TableView Delegate & DataSource
extension FridgeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fridge.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        let item = fridge.items[indexPath.row]

        cell.textLabel?.text = "\(item.name) - \(item.category) (Added by: \(item.memberName))"

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 1. Remove the item from the data source
            let deletedItem = fridge.items[indexPath.row]
            
            Task {
                await deleteItemFromFridge(item: deletedItem)
            }
            
            navigationController?.popViewController(animated: false)
        }
    }
}
