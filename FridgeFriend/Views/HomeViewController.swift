//
//  HomeViewController.swift
//  FridgeFriend
//
//  Created by Ahaan Chaudhuri on 12/7/24.
//


import UIKit

class HomeViewController: UIViewController {
    // UI Components
    private let tableView = UITableView()
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["My Fridges", "Friends"])
        control.selectedSegmentIndex = 0
        return control
    }()
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // Data Models
    private var currentUser: User = User(uid: "password123", username: "exampleUser", friends: [], fridges: [])
    private var displayedFridges: [Fridge] {
        return currentUser.fridges
    }
    private var displayedFriends: [User] {
        return currentUser.friends
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        // Add Subviews
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        view.addSubview(addButton)

        // Configure TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        // Set Constraints
        setConstraints()

        // Add Targets
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }

    private func setConstraints() {
        // Use AutoLayout for positioning
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // Actions
    @objc private func segmentedControlChanged() {
        tableView.reloadData()
    }

    @objc private func addButtonTapped() {
        let selectedIndex = segmentedControl.selectedSegmentIndex
        if selectedIndex == 0 {
            // Add Fridge
            print("Add Fridge tapped")
        } else {
            // Add Friend
            print("Add Friend tapped")
        }
    }
}

// TableView Delegate & DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segmentedControl.selectedSegmentIndex == 0 ? displayedFridges.count : displayedFriends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if segmentedControl.selectedSegmentIndex == 0 {
            let fridge = displayedFridges[indexPath.row]
            cell.textLabel?.text = fridge.name
        } else {
            let friend = displayedFriends[indexPath.row]
            cell.textLabel?.text = friend.username
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            let fridge = displayedFridges[indexPath.row]
            print("Selected fridge: \(fridge.name)")
        } else {
            let friend = displayedFriends[indexPath.row]
            print("Selected friend: \(friend.username)")
        }
    }
}
