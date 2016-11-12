//
//  NetworkRouter.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/7/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import Foundation
import Alamofire

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
