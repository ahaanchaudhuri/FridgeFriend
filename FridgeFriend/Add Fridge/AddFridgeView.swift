//
//  AddFridgeView.swift
//  FridgeFriend
//
//  Created by Rohil Doshi on 12/9/24.
//

import UIKit

class AddFridgeView: UIView {
    
    var fridgeNameTextField: UITextField!
    var members: UITextField!
    var submitButton: UIButton!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        setupTextFieldFridge()
        setupSubmitButton()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupTextFieldFridge(){
        fridgeNameTextField = UITextField()
        fridgeNameTextField.placeholder = "Fridge Name"
        fridgeNameTextField.keyboardType = .default
        fridgeNameTextField.borderStyle = .roundedRect
        fridgeNameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(fridgeNameTextField)
    }
    
    func setupSubmitButton(){
        submitButton = UIButton(type: .system)
        submitButton.setTitle("Create Fridge", for: .normal)
        submitButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(submitButton)
    }

    
    func initConstraints(){
        NSLayoutConstraint.activate([
            fridgeNameTextField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            fridgeNameTextField.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            fridgeNameTextField.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            submitButton.topAnchor.constraint(equalTo: fridgeNameTextField.bottomAnchor, constant: 16),
            submitButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor)
        ])
    }

}
