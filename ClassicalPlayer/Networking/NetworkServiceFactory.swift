//
//  APIRouterFactory.swift
//  ClassicalPlayer
//
//  Created by Andrii Kravchenko on 21.12.17.
//

import Foundation

enum APIPath: String {
    case composers = "/metadata/composers"
    case videos = "/search"
}

enum ParsingError: Error {
    case jsonCast
    case responseStructure
    case noData
    
    var localizedDescription: String {
        switch self {
        case .jsonCast: return "Convert to JSON error".localized()
        case .responseStructure: return "Unable to parse response".localized()
        case .noData: return "No expected response data".localized()
        }
    }
}

protocol NetworkServiceFactoryProtocol {
    func composersService() -> ComposersServiceProtocol
    func videoSearchService() -> VideoSearchServiceProtocol
}

final class NetworkServiceFactory: NetworkServiceFactoryProtocol {
    func composersService() -> ComposersServiceProtocol {
        let router = APIRouter(config: IdagioConfiguration(), path: .composers)
        return ComposersService(router: router)
    }
    
    func videoSearchService() -> VideoSearchServiceProtocol {
        let router = APIRouter(config: YoutubeConfiguration(), path: .videos)
        return VideoSearchService(router: router)
    }
}
