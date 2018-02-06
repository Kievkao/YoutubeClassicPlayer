//
//  Video.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/7/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import Foundation

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

    static func predicateForComposerName(_ name: String) -> NSPredicate {
        return NSPredicate(format: "composerName = %@", name)
    }
}
