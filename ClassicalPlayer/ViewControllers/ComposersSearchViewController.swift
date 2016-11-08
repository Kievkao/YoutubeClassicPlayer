//
//  ComposersSearchViewController.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/7/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit

class ComposersSearchViewController: UITableViewController, UISearchResultsUpdating{

    let searchController = UISearchController(searchResultsController: nil)
    let networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        networkManager.loadComsposersWithCompletion { (composers, error) in
            debugPrint("s");
        }
//        networkManager.loadVideos(request: "bach") { [weak self] (videos, error) in
//            
//        }
    }

    func setup() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    func updateSearchResults(for searchController: UISearchController) {

    }
}
