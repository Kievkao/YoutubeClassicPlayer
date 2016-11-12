//
//  PlaybackHolder.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/9/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import Foundation
import XCDYouTubeKit

final class PlaybackHolder {
    static let shared = PlaybackHolder()

    var videoController: XCDYouTubeVideoPlayerViewController!
}
