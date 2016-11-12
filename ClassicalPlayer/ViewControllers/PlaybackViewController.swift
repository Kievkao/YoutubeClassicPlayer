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

    var videoId: String? {
        didSet {
            PlaybackHolder.shared.videoController = XCDYouTubeVideoPlayerViewController()
            PlaybackHolder.shared.videoController.videoIdentifier = (videoId)
        }
    }
    
    @IBOutlet weak var videoContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let videoId = self.videoId {
            PlaybackHolder.shared.videoController.present(in: videoContainerView)
            PlaybackHolder.shared.videoController.moviePlayer.play()
        }
    }

    deinit {
        print("s");
    }

}
