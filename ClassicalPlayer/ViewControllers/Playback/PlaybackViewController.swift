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

        setProgressIndicatorVisibility(true)
        video = dataProvider.currentVideo()

        setupTitles()
        playVideo()

        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(notification:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidReceiveVideo(notif:)), name: NSNotification.Name.XCDYouTubeVideoPlayerViewControllerDidReceiveVideo, object:nil )
    }

    func applicationDidEnterBackground(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            PlaybackHolder.shared.videoController.moviePlayer.play()
        }
    }

    private func setupTitles() {
        videoTitleLabel.text = video?.title
        composerNameLabel.text = composerName
    }

    private func playVideo() {
        PlaybackHolder.shared.videoController = XCDYouTubeVideoPlayerViewController()
        PlaybackHolder.shared.videoController.videoIdentifier = video.videoId
        PlaybackHolder.shared.videoController.present(in: videoContainerView)
        PlaybackHolder.shared.videoController.moviePlayer.play()

        setupTitles()
    }

    func playerDidReceiveVideo(notif: Notification) {
        setProgressIndicatorVisibility(false)
    }

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

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.XCDYouTubeVideoPlayerViewControllerDidReceiveVideo, object: nil)
    }
}
