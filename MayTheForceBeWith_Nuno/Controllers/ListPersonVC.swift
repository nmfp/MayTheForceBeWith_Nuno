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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        setupViews()
        setupNavigationBar()
        fetchPersons()
    }
    
    //MARK: - SetupUI
    private func setupViews() {
        
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Persons"
        
        //TODO: Need to implement search engine
        
    }
    
    //MARK: - Helper Methods
    private func fetchPersons() {
        PersonService.shared.getPersons(with: PersonRouter.all) { (persons: [Person], error) in
            if let error = error {
                print("Error: ", error.localizedDescription)
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.persons = persons
                self?.filteredPersons = persons
                self?.tableView.reloadData()
            }
        }
    }
}

//MARK: - ListPersonVC TableView Delegate/Datasource

extension ListPersonVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPersons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredPersons[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = filteredPersons[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        print("selected person ", person)
    }
}
