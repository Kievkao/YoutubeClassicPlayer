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
    @objc dynamic var title: String = ""
    @objc dynamic var videoId: String = ""
    @objc dynamic var thumbnailURL: String?
    @objc dynamic var composerName: String = ""

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
