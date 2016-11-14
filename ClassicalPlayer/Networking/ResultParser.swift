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

        for case let videoDict as [String: AnyObject] in resultsArray {
            if  let videoId = videoDict["id"]?["videoId"] as? String,
                let title = videoDict["snippet"]?["title"] as? String,
                let thumbnailsDict = videoDict["snippet"]?["thumbnails"] as? [String: AnyObject] {

                var video = Video(title: title, videoId: videoId, thumbnailURL: nil)

                if  let thumbnailURLString = thumbnailsDict["default"]?["url"] as? String,
                    let thumbnailURL = URL(string: thumbnailURLString) {
                    video.thumbnailURL = thumbnailURL
                }

                videos.append(video)
            }
        }

        let pageToken = jsonDict["nextPageToken"] as? String
        return (videos, pageToken)
    }
}
