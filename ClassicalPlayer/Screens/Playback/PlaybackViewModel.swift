//
//  PlaybackDataProvider.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/12/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import Foundation
import RxSwift
import XCDYouTubeKit

protocol PlaybackViewModelProtocol {
    var videoId: Observable<String> { get }
    var progressSubject: PublishSubject<Bool> { get }
    var videoTitle: String? { get }
    var composerName: String? { get }
    
    func getNextVideo()
    func getPreviousVideo()
}

class PlaybackViewModel: PlaybackViewModelProtocol {
    let videos: [Video]
    private(set) var currentIndex = 0
    private let composer: Composer
    
    var video: Video { return videos[currentIndex] }
    let progressSubject = PublishSubject<Bool>()
    
    var videoTitle: String? { return video.title }
    var composerName: String? { return composer.name }
    
    var videoId: Observable<String> { return videoIdVariable.asObservable().filter { $0 != nil }.map { $0! } }
    private let videoIdVariable: Variable<String?>

    init(composer: Composer, videos: [Video], currentIndex: Int) {
        self.composer = composer
        self.videos = videos
        self.currentIndex = currentIndex
        self.videoIdVariable = Variable(videos[currentIndex].videoId)
        
        PlaybackHolder.shared.videoController = XCDYouTubeVideoPlayerViewController()
        
        subscribeForNotifications()
    }
    
    private func subscribeForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(notification:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidReceiveVideo(notif:)), name: NSNotification.Name.XCDYouTubeVideoPlayerViewControllerDidReceiveVideo, object:nil )
    }

    @objc func applicationDidEnterBackground(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            PlaybackHolder.shared.videoController.moviePlayer.play()
        }
    }
    
    @objc func playerDidReceiveVideo(notif: Notification) {
        progressSubject.onNext(false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.XCDYouTubeVideoPlayerViewControllerDidReceiveVideo, object: nil)
    }
    
    func getNextVideo() {
        progressSubject.onNext(true)
        currentIndex = (currentIndex < videos.count - 1) ? currentIndex + 1 : currentIndex
        videoIdVariable.value = videos[currentIndex].videoId
    }
    
    func getPreviousVideo() {
        progressSubject.onNext(true)
        currentIndex = currentIndex > 0 ? currentIndex - 1 : currentIndex
        videoIdVariable.value = videos[currentIndex].videoId
    }
}
