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

    var video: Video? {
        didSet {
            PlaybackHolder.shared.videoController = XCDYouTubeVideoPlayerViewController()
            PlaybackHolder.shared.videoController.videoIdentifier = video?.videoId
        }
    }
    
    @IBOutlet weak var videoContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        videoTitleLabel.text = video?.title

        PlaybackHolder.shared.videoController.present(in: videoContainerView)
        PlaybackHolder.shared.videoController.moviePlayer.play()
    }
}
