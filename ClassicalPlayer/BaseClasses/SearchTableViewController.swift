//
//  SearchTableViewController.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 12/5/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {

    let remainedCellsBeforeLoadMore = 5

    internal var items = [Any]()
    internal var filteredItems = [Any]()

    internal var isDataLoading = false

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.dimsBackgroundDuringPresentation = false
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchController()
    }

    func setupSearchController() {
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchIsActive() ? filteredItems.count : items.count
    }

    func itemFor(indexPath: IndexPath) -> Any {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredItems[indexPath.row]
        }
        else {
            return items[indexPath.row]
        }
    }

    func needToLoadNewPortion(indexPath: IndexPath) -> Bool {
        if !isDataLoading && indexPath.row > (items.count - remainedCellsBeforeLoadMore) {
            isDataLoading = true
            return true
        }
        else {
            return false
        }
    }

    func searchIsActive() -> Bool {
        return searchController.isActive && searchController.searchBar.text != ""
    }

    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
    }

    func filterContentFor(searchText: String) {
        // Overwrite for each particular data type
    }
}
