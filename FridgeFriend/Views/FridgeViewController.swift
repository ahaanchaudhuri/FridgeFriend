//
//  FridgeViewController.swift
//  FridgeFriend
//
//  Created by Ahaan Chaudhuri on 12/7/24.
//

import UIKit

class FridgeViewController: UIViewController {
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

    // Mock Data
    private var fridge: Fridge = Fridge(
        name: "Fridge1",
        members: [],
        items: [
            Item(name: "Milk", category: "Dairy", photo: "", dateAdded: Date(), memberName: "Alice"),
            Item(name: "Eggs", category: "Eggs", photo: "", dateAdded: Date(), memberName: "Bob"),
            Item(name: "Carrots", category: "Vegetables", photo: "", dateAdded: Date(), memberName: "Alice")
        ]
    )

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
        navigationController?.pushViewController(addItemVC, animated: true)
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
}
