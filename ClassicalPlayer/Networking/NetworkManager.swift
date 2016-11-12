//
//  NetworkManager.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/7/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import Foundation
import Alamofire

final class NetworkManager {

    private var pageToken: String?

    func loadComsposersWithCompletion(completion: @escaping (_ composers : Array<Composer>?, Error?) -> Void) {
        Alamofire.request(NetworkRouter.Composers).validate().responseJSON { response in
            if let value = response.result.value as? [String : AnyObject] {
                completion(ResultParser.parseComposers(jsonDict: value), nil)
            }
        }
    }

    func loadVideos(request: String, portionSize: UInt, completion:@escaping (_ videos : Array<Video>?, Error?) -> Void) {
        Alamofire.request(NetworkRouter.Videos(request: request, portionSize: portionSize, pageToken: pageToken)).validate().responseJSON { response in
            if let value = response.result.value as? [String : AnyObject] {
                let parsedResult = ResultParser.parseVideos(jsonDict: value)

                self.pageToken = parsedResult.1
                completion(parsedResult.0, nil)
            }
        }
    }
}
