//
//  ListPersonVC.swift
//  MayTheForceBeWith_Nuno
//
//  Created by Nuno Pereira on 21/06/2019.
//  Copyright © 2019 nMfpCoding. All rights reserved.
//

import UIKit

class ListPersonVC: UITableViewController {
    
    //MARK: - Properties
    
    
    //MARK: - System Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupViews()
        setupNavigationBar()
        
    }
    
    //MARK: - SetupUI
    private func setupViews() {
        
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Persons"
    }
    
    //MARK: - Helper Methods
    
}

//MARK: - ListPersonVC Delegate/Datasource

