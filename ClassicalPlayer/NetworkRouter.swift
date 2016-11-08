//
//  NetworkRouter.swift
//  GithubUsersBrowser
//
//  Created by Mac on 26.07.16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkRouter: URLRequestConvertible {

    static let baseURLPath = "https://api.github.com"

    case Users(page : UInt, amountPerPage: UInt)

    func asURLRequest() throws -> URLRequest {
        let url = try NetworkRouter.baseURLPath.asURL()

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = Alamofire.HTTPMethod.get.rawValue

        switch self {
        case .Users(let page, let amountPerPage):
            urlRequest.url?.appendPathComponent("users")
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["page" : page, "per_page" : amountPerPage])
        }
        return urlRequest
    }
}
