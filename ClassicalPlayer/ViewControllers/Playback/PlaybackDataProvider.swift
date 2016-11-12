//
//  PlaybackDataProvider.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/12/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import Foundation

class PlaybackDataProvider {

    let videos: [Video]
    private(set) var currentIndex = 0

    init(videos: [Video], currentIndex: Int) {
        self.videos = videos
        self.currentIndex = currentIndex;
    }

    func currentVideo() -> Video {
        return videos[currentIndex]
    }

    func nextVideo() -> Video {
        currentIndex = (currentIndex < videos.count - 1) ? currentIndex + 1 : currentIndex
        return currentVideo()
    }

    func previousVideo() -> Video {
        currentIndex = currentIndex > 0 ? currentIndex - 1 : currentIndex
        return currentVideo()
    }
}
