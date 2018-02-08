//
//  PlaybackDataProvider.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/12/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import Foundation
import RxSwift
import RxFlow
import XCDYouTubeKit

protocol PlaybackViewModelProtocol {
    var video: Observable<Video> { get }
    var progressSubject: PublishSubject<Bool> { get }
    var composerName: String? { get }
    
    func getNextVideo()
    func getPreviousVideo()
}

class PlaybackViewModel: PlaybackViewModelProtocol {
    private let videos: [Video]
    private let videoVariable: Variable<Video>
    private let composer: Composer
    private(set) var currentIndex = 0

    var video: Observable<Video> { return videoVariable.asObservable() }
    var composerName: String? { return composer.name }
    let progressSubject = PublishSubject<Bool>()
    
    init(composer: Composer, videos: [Video], currentIndex: Int) {
        self.composer = composer
        self.videos = videos
        self.currentIndex = currentIndex
        self.videoVariable = Variable(videos[currentIndex])
        
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
        videoVariable.value = videos[currentIndex]
    }
    
    func getPreviousVideo() {
        progressSubject.onNext(true)
        currentIndex = currentIndex > 0 ? currentIndex - 1 : currentIndex
        videoVariable.value = videos[currentIndex]
    }
}

extension PlaybackViewModel: Stepper { }
