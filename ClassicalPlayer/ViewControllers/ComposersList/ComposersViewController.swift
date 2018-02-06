//
//  ComposersViewController.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/7/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit

class ComposersViewController: SearchTableViewController, ComposersDataConsumer {
    var viewModel: ComposersViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let factory = NetworkServiceFactory()
        viewModel = ComposersViewModel(composersService: factory.composersService())
        viewModel.dataConsumer = self
        setupSearchController()
        startComposersLoading()
    }

    //MARK: Composers loading && ComposersDataConsumer

    func startComposersLoading() {
        setProgressIndicatorVisibility(true)
        viewModel.loadComposers()
    }

    func composersDidLoad(composers: [Composer]) {
        self.items = composers

        setProgressIndicatorVisibility(false)
        tableView.reloadData()
    }

    //MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComposerCell", for: indexPath) as! ComposerCell

        if let composer = itemFor(indexPath: indexPath) as? Composer {
            cell.setComposerName(name: composer.name!)
        }

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let composer = itemFor(indexPath: tableView.indexPathForSelectedRow!) as? Composer {
            (segue.destination as! VideosViewController).composer = composer
        }
    }

    //MARK: Search controller helpers

    override func filterContentFor(searchText: String) {
        
        filteredItems = items.filter {
            guard let composer = $0 as? Composer else { return false }
            return composer.name!.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}
