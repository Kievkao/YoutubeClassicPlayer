//
//  ComposersViewController.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/7/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit

class ComposersViewController: UITableViewController, UISearchResultsUpdating{

    let searchController = UISearchController(searchResultsController: nil)
    let networkManager = NetworkManager()

    var composers = [Composer]()
    var filteredComposers = [Composer]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        networkManager.loadComsposersWithCompletion { [weak self] (composers, error) in
            guard let strongSelf = self else {
                return
            }

            strongSelf.composers = composers ?? []
            strongSelf.tableView.reloadData()
        }
    }

    func setup() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredComposers.count
        }
        else {
            return composers.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComposerCell", for: indexPath) as! ComposerCell

        let composer = composerFor(indexPath: indexPath)
        cell.nameLabel.text = composer.name

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let composer = composerFor(indexPath: tableView.indexPathForSelectedRow!)
        (segue.destination as! CompositionsViewController).composer = composer
    }

    func composerFor(indexPath: IndexPath) -> Composer {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredComposers[indexPath.row]
        }
        else {
            return composers[indexPath.row]
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
    }

    func filterContentFor(searchText: String, scope: String = "All") {
        filteredComposers = composers.filter { composer in
            return composer.name.lowercased().contains(searchText.lowercased())
        }

        tableView.reloadData()
    }
}
