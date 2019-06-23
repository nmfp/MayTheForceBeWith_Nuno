//
//  PersonDetailVC.swift
//  MayTheForceBeWith_Nuno
//
//  Created by Nuno Pereira on 21/06/2019.
//  Copyright © 2019 nMfpCoding. All rights reserved.
//

import UIKit

class PersonDetailVC: UIViewController {
    
    //MARK: - Properties
    private let person: Person
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = person.name
        return label
    }()

    private lazy var heightLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = person.height
        return label
    }()
    
    private lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = person.gender
        return label
    }()

    private lazy var birthYearLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = person.birthYear
        return label
    }()
    
    //MARK: - Initializers
    init(person: Person) {
        self.person = person
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - System Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupNavigationBar()
    }
    
    //MARK: - SetupUI
    
    private func setupViews() {
        let labelStackView = UIStackView(arrangedSubviews: [nameLabel, heightLabel, genderLabel, birthYearLabel])
        labelStackView.alignment = .center
        labelStackView.axis = .vertical
        
        view.addSubview(labelStackView)
        
        var topAnchor: NSLayoutYAxisAnchor?
        var bottomAnchor: NSLayoutYAxisAnchor?
        
        if #available(iOS 11.0, *) {
            topAnchor = view.safeAreaLayoutGuide.topAnchor
            bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        } else {
            topAnchor = topLayoutGuide.bottomAnchor
            bottomAnchor = bottomLayoutGuide.topAnchor
        }
        
        labelStackView.anchor(top: topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 24.0, left: 24.0, bottom: 0.0, right: 24.0))
    }
    
    private func setupNavigationBar() {
        title = person.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(markAsFavourite))
    }
    
    //MARK: - Helper Methods
    @objc func markAsFavourite() {
        print("\(person)")
        
        FavouriteService.shared.saveFavourite(person: person) { (response, error) in
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }
            
            guard let response = response else { return }
            
            print(response)
        }
    }
    
}

//MARK: - Extension PersonDetailVC

