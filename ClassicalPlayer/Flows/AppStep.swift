//
//  AppStep.swift
//  ClassicalPlayer
//
//  Created by Andrii Kravchenko on 06.02.18.
//  Copyright © 2018 Kievkao. All rights reserved.
//

import RxFlow

enum AppStep: Step {
    case composers
    case videos(composer: Composer)
    case playback(composer: Composer, videos: [Video], initialIndex: Int)
}
