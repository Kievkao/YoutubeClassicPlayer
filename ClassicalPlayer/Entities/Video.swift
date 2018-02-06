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
    let title: String?
    let videoId: String?
    var thumbnailURL: URL?
    var composerName: String?
    
    init(json: [String: AnyObject]) {
        videoId = json["id"]?["videoId"] as? String
        title = json["snippet"]?["title"] as? String
        
        if let thumbnailsDict = json["snippet"]?["thumbnails"] as? [String: AnyObject],
            let thumbnailURLString = thumbnailsDict["default"]?["url"] as? String {
            thumbnailURL = URL(string: thumbnailURLString)
        } else {
            thumbnailURL = nil
        }
    }
    
    init(title: String?, videoId: String?, thumbnailURL: URL?, composerName: String?) {
        self.title = title
        self.videoId = videoId
        self.thumbnailURL = thumbnailURL
        self.composerName = composerName
    }
    
    static func predicateForComposerName(_ name: String) -> NSPredicate {
        return NSPredicate(format: "composerName = %@", name)
    }
}
