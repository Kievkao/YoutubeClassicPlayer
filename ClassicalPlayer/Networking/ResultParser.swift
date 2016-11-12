//
//  ResultParser.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/8/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import Foundation

final class ResultParser {

    static func parseComposers(jsonDict: [String : AnyObject]) -> [Composer]? {
        guard let resultsArray = jsonDict["results"] as? [AnyObject] else {
            return []
        }

        var composers = [Composer]()

        for composerDict in resultsArray {
            if  let name = composerDict["name"] as? String,
                let forename = composerDict["forename"] as? String,
                let surname = composerDict["surname"] as? String {
                let composer = Composer(forename: forename, surname: surname, name: name)
                composers.append(composer)
            }
        }
        return composers
    }

    static func parseVideos(jsonDict: [String : AnyObject]) -> ([Video]?, String?) {
        guard let resultsArray = jsonDict["items"] as? [AnyObject] else {
            return ([], nil)
        }

        var videos = [Video]()

        for videoDict in resultsArray {
            if  let videoId = (videoDict["id"] as? [String: AnyObject])?["videoId"] as? String,
                let title = (videoDict["snippet"] as? [String: AnyObject])?["title"] as? String,
                let thumbnailsDict = (videoDict["snippet"] as? [String: AnyObject])?["thumbnails"] {

                var video = Video(title: title, videoId: videoId, thumbnailURL: nil)

                if let thumbnailURL = (thumbnailsDict["default"]  as? [String: AnyObject])?["url"] as? String {
                    video.thumbnailURL = thumbnailURL
                }

                videos.append(video)
            }
        }

        let pageToken = jsonDict["nextPageToken"] as? String
        return (videos, pageToken)
    }
}
