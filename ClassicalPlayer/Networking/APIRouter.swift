//
//  NetworkRouter.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/7/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import Foundation
import Alamofire

protocol APIRouterProtocol {
    func request(method: RESTMethod, params: [String: String]) -> URLRequest?
}

enum RESTMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

final class APIRouter {
    private let config: Configuration
    private let path: APIPath
    
    init(config: Configuration, path: APIPath) {
        self.config = config
        self.path = path
    }
}

extension APIRouter: APIRouterProtocol {
    func request(method: RESTMethod, params: [String : String]) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = config.scheme
        urlComponents.host = config.host
        urlComponents.path = config.startPath + path.rawValue
        
        var queryItems = [URLQueryItem]()
        
        if let apiKey = config.apiKey, let apiKeyParam = config.apiKeyParameter {
            queryItems.append(URLQueryItem(name: apiKeyParam, value: apiKey))
        }
        
        queryItems.append(contentsOf: params.map {
            URLQueryItem(name: $0.0, value: $0.1)
        })
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}

enum NetworkRouter: URLRequestConvertible {

    static let youtubeURLPath = "https://www.googleapis.com/youtube/v3/search"
    static let idagioURLPath = "http://api.idagio.com/v2.0/metadata/composers"

    static let youtubeApiKey = "AIzaSyAI8_3ZywOy6_FoO_LrfvcxlQLdZaFrTlg"

    case Composers
    case Videos(request : String, portionSize: UInt, pageToken : String?)

    func asURLRequest() throws -> URLRequest {
        let url = try urlPath().asURL()

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = Alamofire.HTTPMethod.get.rawValue

        switch self {
        case .Composers:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)

        case .Videos(let request, let portionSize, let pageToken):
            var parameters: Parameters!

            if let pageToken = pageToken {
                parameters = ["part" : "snippet", "type": "video", "q" : request, "maxResults" : portionSize, "pageToken" : pageToken, "key" : NetworkRouter.youtubeApiKey]
            }
            else {
                parameters = ["part" : "snippet", "type": "video", "q" : request, "maxResults" : portionSize, "key" : NetworkRouter.youtubeApiKey]
            }

            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }

        return urlRequest
    }

    func urlPath() -> String {
        switch self {
        case .Composers:
            return NetworkRouter.idagioURLPath

        default:
            return NetworkRouter.youtubeURLPath
        }
    }
}
