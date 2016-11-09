//
//  PlaybackViewController.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/8/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit

class PlaybackViewController: UIViewController, YTPlayerViewDelegate {

    var videoId: String?

    @IBOutlet weak var playerView: YTPlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        playerView.load(withVideoId: "rrVDATvUitA", playerVars: ["playsinline" : 1, "controls" : 0, "autoplay" : 1, "showinfo": 0])
        playerView.delegate = self
//        if let videoId = self.videoId {
//
//        }
    }

    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }

    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .paused:
            playerView.playVideo()

        default:
            break;
        }
    }

}
