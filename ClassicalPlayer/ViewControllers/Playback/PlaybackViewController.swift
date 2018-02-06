//
//  PlaybackViewController.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/8/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit
import XCDYouTubeKit

class PlaybackViewController: UIViewController {

    @IBOutlet weak var composerNameLabel: UILabel!
    @IBOutlet weak var videoTitleLabel: UILabel!

    private(set) var video: Video!

    var dataProvider: PlaybackDataProvider! {
        didSet {
            PlaybackHolder.shared.videoController = XCDYouTubeVideoPlayerViewController()
        }
    }

    var composerName: String?
    
    @IBOutlet weak private var videoContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        video = dataProvider.currentVideo()

        setProgressIndicatorVisibility(true)
        setupTitles()
        subscribeForNotifications()
        playVideo()
    }

    private func setupTitles() {
        videoTitleLabel.text = video?.title
        composerNameLabel.text = composerName
    }

    private func subscribeForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(notification:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidReceiveVideo(notif:)), name: NSNotification.Name.XCDYouTubeVideoPlayerViewControllerDidReceiveVideo, object:nil )
    }

    private func playVideo() {
        PlaybackHolder.shared.videoController = XCDYouTubeVideoPlayerViewController()
        PlaybackHolder.shared.videoController.videoIdentifier = video.videoId
        PlaybackHolder.shared.videoController.present(in: videoContainerView)
        PlaybackHolder.shared.videoController.moviePlayer.play()

        setupTitles()
    }

    //MARK: XCDYouTubeVideoPlayer delegate

    @objc func playerDidReceiveVideo(notif: Notification) {
        setProgressIndicatorVisibility(false)
    }

    //MARK: Actions

    @IBAction func previousButtonAction(_ sender: UIButton) {
        setProgressIndicatorVisibility(true)
        video = dataProvider.nextVideo()
        playVideo()
    }

    @IBAction func nextButtonAction(_ sender: UIButton) {
        setProgressIndicatorVisibility(true)
        video = dataProvider.nextVideo()
        playVideo()
    }

    //MARK: Other

    @objc func applicationDidEnterBackground(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            PlaybackHolder.shared.videoController.moviePlayer.play()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.XCDYouTubeVideoPlayerViewControllerDidReceiveVideo, object: nil)
    }
}
