//
//  ComposersService.swift
//  ClassicalPlayer
//
//  Created by Andrii Kravchenko on 22.12.17.
//

import UIKit
import Alamofire

protocol ComposersServiceProtocol {
    func loadComposers(completion: @escaping (([Composer]?, Error?) -> Void))
}

final class ComposersService: ComposersServiceProtocol {
    private let router: APIRouterProtocol
    
    init(router: APIRouterProtocol) {
        self.router = router
    }
    
    func loadComposers(completion: @escaping (([Composer]?, Error?) -> Void)) {
        guard let request = router.request(method: .get, params: [:]) else { return }
        
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
            
            completion(results.map { Composer(json: $0) }, nil)
        }
    }
}
