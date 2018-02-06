//
//  VideosViewController.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/7/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit

class VideosViewController: UITableViewController, ComposerVideosDataConsumer {

    let remainedCellsBeforeLoadMore = 5
    let tableViewEstimatedRowHeight: CGFloat = 50.0

    private var viewModel: VideosViewModel!
    
    private(set) var isDataLoading = false

    var composer: Composer? {
        didSet {
            let factory = NetworkServiceFactory()
            viewModel = VideosViewModel(videosService: factory.videoSearchService(), composerName:composer!.name!, portionSize: 20)
            viewModel.dataConsumer = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        startVideosLoading()
    }

    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = tableViewEstimatedRowHeight
    }

    private func startVideosLoading() {
        setProgressIndicatorVisibility(true)
        isDataLoading = true
        viewModel.loadNextVideos()
    }

    //MARK: ComposerVideosDataConsumer

    func videosDidLoad() {
        isDataLoading = false
        setProgressIndicatorVisibility(false)
        tableView.reloadData()
    }

    //MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfVideos()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompositionCell", for: indexPath) as! CompositionCell
        let video = viewModel.videoForIndexPath(indexPath: indexPath)

        configureCell(cell: cell, withVideo: video)

        if needToLoadNewPortion(indexPath: indexPath) {
            viewModel.loadNextVideos()
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.cancelImageLoadingFor(video: viewModel.videoForIndexPath(indexPath: indexPath));
    }

    private func configureCell(cell: CompositionCell, withVideo video: Video) {
        cell.setName(name: video.title!)
        cell.setThumbnail(image: UIImage.placeholderImage())

        viewModel.loadImageFor(video: video) { (image) in
            if let image = image {
                cell.setThumbnail(image: image)
            }
        }
    }

    private func needToLoadNewPortion(indexPath: IndexPath) -> Bool {
        if !isDataLoading && indexPath.row > (viewModel.numberOfVideos() - remainedCellsBeforeLoadMore) {
            isDataLoading = true
            return true
        }
        else {
            return false
        }
    }

    //MARK: Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let playbackViewController = segue.destination as! PlaybackViewController

        playbackViewController.viewModel = PlaybackViewModel(videos: viewModel.allVideos(), currentIndex: tableView.indexPathForSelectedRow!.row)
        playbackViewController.composerName = composer?.name
    }
}
