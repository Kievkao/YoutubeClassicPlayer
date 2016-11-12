//
//  VideoListDataProvider.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/12/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit

class VideoListDataProvider {

    let portionSize: UInt
    let composerName: String

    private let networkManager = NetworkManager()
    private let imageLoader = VideoListImagesLoader()

    private(set) var videos = [Video]()

    weak var dataConsumer: VideosViewController?

    init(composerName: String, portionSize: UInt) {
        self.composerName = composerName
        self.portionSize = portionSize
    }

    func loadNextVideos() {
        networkManager.loadVideos(request: self.composerName, portionSize: portionSize) {  [weak self] (videos, error) in
            guard let strongSelf = self else {
                return
            }

            guard let videos = videos else {
                return
            }

            strongSelf.videos.append(contentsOf: videos)
            strongSelf.dataConsumer?.videosDidLoad()
        }
    }

    func numberOfVideos() -> Int {
        return videos.count
    }

    func videoForIndexPath(indexPath: IndexPath) -> Video {
        return videos[indexPath.row]
    }

    func allVideos() -> [Video] {
        return videos
    }

    func loadImageFor(video: Video, completion:@escaping (_ image : UIImage?) -> Void) {
        guard let imageURL = video.thumbnailURL else {
            completion(nil)
            return
        }

        imageLoader.loadImageFor(imageURL: imageURL, completion: completion)
    }

    func cancelImageLoadingFor(video: Video) {
        if let imageURL = video.thumbnailURL {
            imageLoader.cancelImageLoadingFor(imageURL: imageURL)
        }
    }
}
