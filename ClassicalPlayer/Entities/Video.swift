//
//  Video.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/7/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import Foundation
import RealmSwift

class VideoRealm: Object {
    dynamic var title: String = ""
    dynamic var videoId: String = ""
    dynamic var thumbnailURL: String?
    dynamic var composerName: String = ""

    func plain() -> Video {
        return Video(title: title, videoId: videoId, thumbnailURL: thumbnailURL != nil ? URL(string: thumbnailURL!) : nil, composerName: composerName)
    }
}

struct Video {
    let title: String
    let videoId: String
    var thumbnailURL: URL?
    var composerName: String

    static func predicateForComposerName(_ name: String) -> NSPredicate {
        return NSPredicate(format: "composerName = %@", name)
    }
}
