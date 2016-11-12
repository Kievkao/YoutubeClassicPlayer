//
//  ComposersViewController.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/7/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit

class ComposersViewController: UITableViewController, UISearchResultsUpdating{

    private lazy var dataProvider: ComposersListDataProvider = {
        let composersProvider = ComposersListDataProvider()
        composersProvider.dataConsumer = self
        return composersProvider
    }()

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.dimsBackgroundDuringPresentation = false
        return controller
    }()

    private(set) var composers = [Composer]()
    private(set) var filteredComposers = [Composer]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchController()
        startComposersLoading()
    }

    func setupSearchController() {
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    func startComposersLoading() {
        setProgressIndicatorVisibility(true)
        dataProvider.loadComposers()
    }

    //MARK: ComposersListDataProvider callback

    func composersDidLoad(composers: [Composer]) {
        self.composers = composers

        setProgressIndicatorVisibility(false)
        tableView.reloadData()
    }

    //MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchIsActive() ? filteredComposers.count : composers.count
    }

    func searchIsActive() -> Bool {
        return searchController.isActive && searchController.searchBar.text != ""
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComposerCell", for: indexPath) as! ComposerCell

        let composer = composerFor(indexPath: indexPath)
        cell.nameLabel.text = composer.name

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let composer = composerFor(indexPath: tableView.indexPathForSelectedRow!)
        (segue.destination as! VideosViewController).composer = composer
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
