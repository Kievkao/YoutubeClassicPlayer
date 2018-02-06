//
//  SearchRouter.swift
//  ClassicalPlayer
//
//  Created by Andrii Kravchenko on 21.12.17.
//

import Foundation
import Alamofire

protocol VideoSearchServiceProtocol {
    func searchVideos(_ query: String, portionSize: UInt, pageToken : String?, completion: @escaping ([Video]?, Error?) -> Void)
}

final class VideoSearchService: VideoSearchServiceProtocol {
    private let router: APIRouterProtocol
    
    init(router: APIRouterProtocol) {
        self.router = router
    }
    
    func searchVideos(_ query: String, portionSize: UInt, pageToken : String?, completion: @escaping ([Video]?, Error?) -> Void) {
        var params: [String: String] = ["part" : "snippet", "type": "video", "q" : query, "maxResults" : String(portionSize)]
        
        if let pageToken = pageToken {
            params["pageToken"] = pageToken
        }
        
        guard let request = router.request(method: .get, params: params) else { return }
        
        Alamofire.request(request).responseJSON { response in
            let error = response.error
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let json = response.result.value as? [String: AnyObject] else {
                completion(nil, ParsingError.jsonCast)
                return
            }
            
            guard let results = json["results"] as? [[String: AnyObject]] else {
                completion(nil, ParsingError.responseStructure)
                return
            }
            
            completion(results.map { Video(json: $0) }, nil)
        }
    }
}
