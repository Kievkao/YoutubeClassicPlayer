//
//  SearchRouter.swift
//  ClassicalPlayer
//
//  Created by Andrii Kravchenko on 21.12.17.
//

import Foundation
import Alamofire

protocol VideoSearchServiceProtocol {
    func searchVideos(_ query: String, portionSize: UInt, pageToken : String?, completion: @escaping ([Video]?, String?, Error?) -> Void)
}

final class VideoSearchService: VideoSearchServiceProtocol {
    private let router: APIRouterProtocol
    
    init(router: APIRouterProtocol) {
        self.router = router
    }
    
    func searchVideos(_ query: String, portionSize: UInt, pageToken : String?, completion: @escaping ([Video]?, String?, Error?) -> Void) {
        var params: [String: String] = ["part" : "snippet", "type": "video", "q" : query, "maxResults" : String(portionSize)]
        
        if let pageToken = pageToken {
            params["pageToken"] = pageToken
        }
        
        guard let request = router.request(method: .get, params: params) else { return }
        
        Alamofire.request(request).responseJSON(options: .allowFragments) { response in
            let error = response.error
            guard error == nil else {
                completion(nil, pageToken, error)
                return
            }
            
            guard let json = response.result.value as? [String: AnyObject] else {
                completion(nil, pageToken, ParsingError.jsonCast)
                return
            }
            
            guard let results = json["items"] as? [[String: AnyObject]] else {
                completion(nil, pageToken, ParsingError.responseStructure)
                return
            }
            
            let nextPageToken = json["nextPageToken"] as? String
            completion(results.map { Video(json: $0) }, nextPageToken, nil)
        }
    }
}
