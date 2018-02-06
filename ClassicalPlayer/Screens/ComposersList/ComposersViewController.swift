//
//  ComposersViewController.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/7/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ComposersViewController: UITableViewController {
    var viewModel: ComposersViewModelProtocol!
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.dimsBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Composer".localized()
        return controller
    }()
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = .gray
        indicator.center = view.center
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var isSearchActive: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    private var items: [Composer] {
        guard isSearchActive, let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            return viewModel.composers.value
        }
        return viewModel.composers.value.filter { $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.isEnabled = true
    }
    
    private func setupUI() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = UIView()
        
        definesPresentationContext = true
        view.addSubview(activityIndicator)
    }
    
    private func bindViewModel() {
        viewModel.composers.asObservable()
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        viewModel.errorSubject
            .bind(to: rx.errorPresentor)
            .disposed(by: disposeBag)
        
        viewModel.progressSubject
            .bind(to: rx.progress)
            .disposed(by: disposeBag)
    }

    //MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComposerCell", for: indexPath) as! ComposerCell
        let composer = items[indexPath.row]

        cell.setComposerName(name: composer.name!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if let composer = itemFor(indexPath: tableView.indexPathForSelectedRow!) as? Composer {
//            (segue.destination as! VideosViewController).composer = composer
//        }
    }
}

extension ComposersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        tableView.reloadData()
    }
}

extension ComposersViewController: StoryboardBased {
    static func instantiate() -> ComposersViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ComposersViewController") as! ComposersViewController
    }
}

extension Reactive where Base: ComposersViewController {
    var progress: Binder<Bool> {
        return Binder(self.base) { controller, inProgress in
            if inProgress {
                controller.activityIndicator.startAnimating()
            } else {
                controller.activityIndicator.stopAnimating()
            }
        }
    }
}
