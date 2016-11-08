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

    var composers: [Composer]?

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        networkManager.loadComsposersWithCompletion { [weak self] (composers, error) in
            guard let strongSelf = self else {
                return
            }

            strongSelf.composers = composers

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
        return composers?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ComposerCell", for: indexPath) as! ComposerCell

        if let composer = composers?[indexPath.row] {
            cell.nameLabel.text = composer.name
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    func updateSearchResults(for searchController: UISearchController) {

    }
}
