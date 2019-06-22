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
    private var persons = [Person]()
    private var filteredPersons = [Person]()
    private var elementsPerPage = 10
    private var hasNext: Bool = false
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = .gray
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    //MARK: - System Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupNavigationBar()
        fetchPersons()
    }
    
    //MARK: - SetupUI
    private func setupViews() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = loadingIndicator
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Persons"
        
        //TODO: Need to implement search engine
        
    }
    
    //MARK: - Helper Methods
    private func fetchPersons(_ page: Int = 1) {
        print("Fetching page: ", page)
        PersonService.shared.getPersons(with: PersonRouter.page(page)) { (response, error) in
            if let error = error {
                print("Error: ", error.localizedDescription)
                return
            }
            
            guard let personResponse = response else { return }
            
            self.hasNext = personResponse.hasNextPage
            self.persons += personResponse.results
            self.filteredPersons = self.persons
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
        let detailVC = PersonDetailVC(person: person)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == filteredPersons.count - 1 else { return }
        if hasNext {
            let nextPage = persons.count.quotientAndRemainder(dividingBy: elementsPerPage).quotient + 1
            fetchPersons(nextPage)
        } else {
            loadingIndicator.stopAnimating()
            tableView.tableFooterView = nil
        }
    }
}
