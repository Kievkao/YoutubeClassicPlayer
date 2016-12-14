//
//  ComposerVideosLoader.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/12/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit

protocol ComposerVideosDataConsumer: class {
    func videosDidLoad()
}

class ComposerVideosDataProvider {

    let portionSize: UInt
    let composerName: String

    private let networkManager = NetworkManager()
    private let storageManager = StorageManager()
    private let imagesLoader = ImagesLoader()

    private var videos = [Video]()

    weak var dataConsumer: ComposerVideosDataConsumer?

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

            if strongSelf.storageManager.saveObjects(videos) != nil {
                print("Realm save operation error")
            }

            var plainVideos = [Video]()

            for realmObj in videos {
                plainVideos.append(realmObj.plain())
            }

            strongSelf.videos.append(contentsOf:plainVideos)
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

        imagesLoader.loadImageFor(imageURL: imageURL, completion: completion)
    }

    func cancelImageLoadingFor(video: Video) {
        if let imageURL = video.thumbnailURL {
            imagesLoader.cancelImageLoadingFor(imageURL: imageURL)
        }
    }
}
