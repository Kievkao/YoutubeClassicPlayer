//
//  NetworkManager.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/7/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import OAuthSwift
import OAuthSwiftAlamofire

final class NetworkManager {

    func loadComsposersWithCompletion(completion: @escaping (_ composers : Array<Composer>?, Error?) -> Void) {
        Alamofire.request(NetworkRouter.Composers).validate().responseJSON { response in
            if let value = response.result.value as? [String : AnyObject] {
                completion(ResultParser.parseComposers(jsonDict: value), nil);
            }
        }
    }

    func loadVideos(request : String, completion:@escaping (_ videos : Array<Video>?, Error?) -> Void) {
        Alamofire.request(NetworkRouter.Videos(request: request)).validate().responseJSON { response in
            if let value = response.result.value as? [String : AnyObject] {
                completion(ResultParser.parseVideos(jsonDict: value), nil);
            }
        }
    }
}
