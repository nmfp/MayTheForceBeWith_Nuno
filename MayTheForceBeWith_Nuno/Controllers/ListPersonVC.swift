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
    var persons = [Person]()
    var filteredPersons = [Person]()
    
    //MARK: - System Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupNavigationBar()
        
    }
    
    //MARK: - SetupUI
    private func setupViews() {
        PersonService.shared.getPersons(with: PersonRouter.all) { (persons: [Person], error) in
            if let error = error {
                print("Error: ", error.localizedDescription)
                return
            }
            
            print(persons.count)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Persons"
        
        //TODO: Need to implement search engine
        
    }
    
    //MARK: - Helper Methods
    
}

//MARK: - ListPersonVC Delegate/Datasource

