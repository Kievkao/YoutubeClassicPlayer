//
//  VideosViewController.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/7/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit

class VideosViewController: UITableViewController {

    let remainedCellsBeforeLoadMore = 5
    let tableViewEstimatedRowHeight: CGFloat = 50.0

    private var dataProvider: VideoListDataProvider!
    private(set) var isDataLoading = false

    var composer: Composer? {
        didSet {
            dataProvider = VideoListDataProvider(composerName:composer!.name, portionSize: 20)
            dataProvider.dataConsumer = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        startVideosLoading()
    }

    func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = tableViewEstimatedRowHeight
    }

    func startVideosLoading() {
        setProgressIndicatorVisibility(true)
        isDataLoading = true
        dataProvider.loadNextVideos()
    }

    //MARK: VideoListDataProvider callback

    func videosDidLoad() {
        isDataLoading = false
        setProgressIndicatorVisibility(false)
        tableView.reloadData()
    }

    private func needToLoadNewPortion(indexPath: IndexPath) -> Bool {
        if !isDataLoading && indexPath.row > (dataProvider.numberOfVideos() - remainedCellsBeforeLoadMore) {
            isDataLoading = true
            return true
        }
        else {
            return false
        }
    }

    //MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.numberOfVideos()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompositionCell", for: indexPath) as! CompositionCell
        let video = dataProvider.videoForIndexPath(indexPath: indexPath)

        configureCell(cell: cell, withVideo: video)

        if needToLoadNewPortion(indexPath: indexPath) {
            dataProvider.loadNextVideos()
        }
        
        return cell
    }

    func configureCell(cell: CompositionCell, withVideo video: Video) {
        cell.nameLabel.text = video.title
        cell.thumbnailImageView.image = UIImage.placeholderImage()

        dataProvider.loadImageFor(video: video) { (image) in
            if let image = image {
                cell.thumbnailImageView.image = image
            }
        }
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        dataProvider.cancelImageLoadingFor(video: dataProvider.videoForIndexPath(indexPath: indexPath));
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let video = dataProvider.videoForIndexPath(indexPath: tableView.indexPathForSelectedRow!)

        let playbackViewController = segue.destination as! PlaybackViewController
        playbackViewController.video = video
        playbackViewController.composerName = composer?.name
    }
}
