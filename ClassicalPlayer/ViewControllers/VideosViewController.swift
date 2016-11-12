//
//  VideosViewController.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/7/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit

class VideosViewController: UITableViewController {

    let RemainedCellsBeforeLoadMore = 5

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

        startVideosLoading()
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
        if !isDataLoading && indexPath.row > (dataProvider.numberOfVideos() - RemainedCellsBeforeLoadMore) {
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
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let video = dataProvider.videoForIndexPath(indexPath: tableView.indexPathForSelectedRow!)
        (segue.destination as! PlaybackViewController).videoId = video.videoId
    }
}
