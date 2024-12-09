//
//  AddItemViewController.swift
//  FridgeFriend
//
//  Created by Ahaan Chaudhuri on 12/7/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var currentUser:FirebaseAuth.User?
    var currentFridge: Fridge!
    
    // UI Components
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter item name"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let categoryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter category"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    private let photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Photo", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Add Item"

        // Add Subviews
        view.addSubview(nameTextField)
        view.addSubview(categoryTextField)
        view.addSubview(datePicker)
        view.addSubview(photoButton)
        view.addSubview(saveButton)

        // Add Targets
        photoButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

        // Set Constraints
        setConstraints()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            categoryTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            categoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            datePicker.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 16),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            photoButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 16),
            photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            saveButton.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 32),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func photoButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        // Handle the selected image if needed
    }

    @objc private func saveButtonTapped() {
        let name = nameTextField.text ?? ""
        let category = categoryTextField.text ?? ""
        let dateAdded = datePicker.date
        
        let newItem : Item = Item(name: name, category: category, photo: "", dateAdded: dateAdded, memberName: ((self.currentUser?.email)!))
        
        Task {
            await addItemToFride(item: newItem)
        }


        print("Item saved: \(name), \(category), \(dateAdded)")
        navigationController?.popViewController(animated: true)
    }
    
    
    func addItemToFride(item: Item) async {
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
            .document((self.currentFridge?.id)!)
        
        do {
            let querySnapshot = try await fridgesRef.updateData([
                "items": FieldValue.arrayUnion([itemData])
              ])
        } catch {
            print("Error adding item to fridge: \(error.localizedDescription)")
        }
    }
}
