//
//  MainView.swift
//  FridgeFriend
//
//  Created by Rohil Doshi on 12/8/24.
//

import UIKit

class MainView: UIView {
    var profilePic: UIImageView!
    var labelText: UILabel!
    var floatingButtonAddFridge: UIButton!
    var tableViewFridges: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupProfilePic()
        setupLabelText()
        setupFloatingButtonAddFridge() 
        setupTableViewFridges()
        initConstraints()
    }
    
    //MARK: initializing the UI elements...
    func setupProfilePic(){
        profilePic = UIImageView()
        profilePic.image = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysOriginal)
        profilePic.contentMode = .scaleToFill
        profilePic.clipsToBounds = true
        profilePic.layer.masksToBounds = true
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profilePic)
    }
    
    func setupLabelText(){
        labelText = UILabel()
        labelText.font = .boldSystemFont(ofSize: 14)
        labelText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelText)
    }
    
    func setupTableViewFridges(){
        tableViewFridges = UITableView()
        tableViewFridges.register(FridgesTableViewCell.self, forCellReuseIdentifier: Configs.fridgeViewContactsID)
        tableViewFridges.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewFridges)
    }
    
    func setupFloatingButtonAddFridge(){
        floatingButtonAddFridge = UIButton(type: .system)
        floatingButtonAddFridge.setTitle("", for: .normal)
        floatingButtonAddFridge.setImage(UIImage(systemName: "person.crop.circle.fill.badge.plus")?.withRenderingMode(.alwaysOriginal), for: .normal)
        floatingButtonAddFridge.contentHorizontalAlignment = .fill
        floatingButtonAddFridge.contentVerticalAlignment = .fill
        floatingButtonAddFridge.imageView?.contentMode = .scaleAspectFit
        floatingButtonAddFridge.layer.cornerRadius = 16
        floatingButtonAddFridge.imageView?.layer.shadowOffset = .zero
        floatingButtonAddFridge.imageView?.layer.shadowRadius = 0.8
        floatingButtonAddFridge.imageView?.layer.shadowOpacity = 0.7
        floatingButtonAddFridge.imageView?.clipsToBounds = true
        floatingButtonAddFridge.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(floatingButtonAddFridge)
    }
    
    
    //MARK: setting up constraints...
    func initConstraints(){
        NSLayoutConstraint.activate([
            profilePic.widthAnchor.constraint(equalToConstant: 32),
            profilePic.heightAnchor.constraint(equalToConstant: 32),
            profilePic.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            profilePic.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            labelText.topAnchor.constraint(equalTo: profilePic.topAnchor),
            labelText.bottomAnchor.constraint(equalTo: profilePic.bottomAnchor),
            labelText.leadingAnchor.constraint(equalTo: profilePic.trailingAnchor, constant: 8),
            
            tableViewFridges.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 8),
            tableViewFridges.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableViewFridges.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewFridges.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            floatingButtonAddFridge.widthAnchor.constraint(equalToConstant: 48),
            floatingButtonAddFridge.heightAnchor.constraint(equalToConstant: 48),
            floatingButtonAddFridge.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            floatingButtonAddFridge.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
