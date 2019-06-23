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
    private var hasNext = false
    private var fetchedAll = false
    private var timer: Timer?
    private var isSearching = false
    private var searchController: UISearchController!
    
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
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
//        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        
        if #available(iOS 11, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    //MARK: - Helper Methods
    private func fetchPersons(_ page: Int = 1) {
        print("Fetching page: ", page)
        
        if isSearching {
            searchPersons(by: searchController.searchBar.text ?? "", page: page)
            return
        }
        
        PersonService.shared.getPersons(in: page) { (response, error) in
            if let error = error {
                print("Error: ", error.localizedDescription)
                return
            }
            
            guard let personResponse = response else { return }
            self.fetchedAll = !personResponse.hasNextPage
            self.hasNext = personResponse.hasNextPage
            self.persons += personResponse.results
            self.filteredPersons = self.persons
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func searchPersons(by name: String, page: Int? = nil) {
        guard !name.isEmpty else {
            resetSearchedResults()
            return
        }
        
        guard !fetchedAll else {
            filteredPersons = persons.filter({ $0.name.lowercased().contains(name.lowercased()) })
            tableView.reloadData()
            print("Ja descarregou todos e nao faz pedido a api")
            return
        }
        
        print("Ainda faltam personagens para descarregar e faz pedido a api")
        
        if page == nil {
            filteredPersons.removeAll()
        }
        
        PersonService.shared.searchPersons(by: name, page: page) { (response, error) in
            if let error = error {
                print("Error: ", error.localizedDescription)
                return
            }
            
            guard let personResponse = response else { return }
            
            self.hasNext = personResponse.hasNextPage
            self.filteredPersons += personResponse.results
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func handleSearch() {
        searchPersons(by: searchController.searchBar.text ?? "")
    }
    
    private func resetSearchedResults() {
        isSearching = false
        hasNext = !fetchedAll
        filteredPersons = persons
        loadingIndicator.startAnimating()
        tableView.tableFooterView = loadingIndicator
        tableView.reloadData()
    }
    
    deinit {
        timer = nil
    }
}

//MARK: - ListPersonVC TableView Delegate/Datasource

extension ListPersonVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPersons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let person = filteredPersons[indexPath.row]
        cell.textLabel?.text = person.name
        cell.accessoryType = person.isFavourite ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = filteredPersons[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = PersonDetailVC(person: person)
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == filteredPersons.count - 1 else { return }
        
        if hasNext {
            let nextPage = filteredPersons.count.quotientAndRemainder(dividingBy: elementsPerPage).quotient + 1
            fetchPersons(nextPage)
        }
        else {
            loadingIndicator.stopAnimating()
            tableView.tableFooterView = UIView()
        }
    }
}

extension ListPersonVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = !searchText.isEmpty
        
        timer?.invalidate()
        
        if #available(iOS 10, *) {
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
                self.searchPersons(by: searchText)
            }
        } else {
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(handleSearch), userInfo: nil, repeats: false)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("canceled")
        resetSearchedResults()
    }
}

extension ListPersonVC: UISearchControllerDelegate {
    
}

extension ListPersonVC: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        print(searchController.searchBar.text)
    }
}

extension ListPersonVC: FavouriteDeletegate {
    func saveFavourite(person: Person) {
        if let index = persons.firstIndex(where: { $0.name == person.name}) {
            var favourite = person
            favourite.setAsFavourite()
            persons[index] = favourite
            
            if !isSearching {
                filteredPersons[index] = favourite
            }
            
            DispatchQueue.main.async {
                let indexToReload = IndexPath(row: index, section: 0)
                self.tableView.reloadRows(at: [indexToReload], with: .automatic)
            }
        }
    }
}

protocol FavouriteDeletegate: class {
    func saveFavourite(person: Person)
}
