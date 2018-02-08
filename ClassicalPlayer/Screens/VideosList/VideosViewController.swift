//
//  VideosViewController.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/7/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class VideosViewController: UITableViewController {
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = .gray
        indicator.center = view.center
        indicator.hidesWhenStopped = true
        return indicator
    }()

    var viewModel: VideosViewModelProtocol!

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
        tableView.tableFooterView = UIView()
    }

    private func bindViewModel() {
        viewModel.videos.asObservable()
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.videos.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
        cell.viewModel = VideoCellViewModel(imagesLoader: viewModel.imagesLoader, video: viewModel.videos.value[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if needToLoadNewPortion(indexPath: indexPath) {
            viewModel.loadNextPage()
        }
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? VideoCell else { return }
        cell.viewModel.cancelImageLoading()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectVideo(at: indexPath.row)
    }

    private func needToLoadNewPortion(indexPath: IndexPath) -> Bool {
        return indexPath.row > (viewModel.videos.value.count - 3)
    }
}

extension VideosViewController: StoryboardBased {
    static func instantiate() -> VideosViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideosViewController") as! VideosViewController
    }
}

extension Reactive where Base: VideosViewController {
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
