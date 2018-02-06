//
//  Configuration.swift
//  ClassicalPlayer
//
//  Created by Andrii Kravchenko on 21.12.17.
//

import Foundation

protocol Configuration {
    var host: String { get }
    var startPath: String { get }
    var scheme: String { get }
    var apiKey: String? { get }
    var apiKeyParameter: String? { get }
    
    var configDict: [String: AnyObject] { get }
}

extension Configuration {
    var apiKey: String? { return nil }
    var apiKeyParameter: String? { return nil }
}

extension Configuration {
    var configDict: [String: AnyObject] {
        let plistPath = Bundle.main.path(forResource: "Info", ofType: "plist")!
        let plistData = FileManager.default.contents(atPath: plistPath)!
        var format = PropertyListSerialization.PropertyListFormat.xml
        return try! PropertyListSerialization.propertyList(from: plistData, options: .mutableContainersAndLeaves, format: &format) as! [String : AnyObject]
    }
}

final class IdagioConfiguration: Configuration {
    var host: String {
        return configDict["idagioHost"] as! String
    }
    
    var startPath: String {
        return configDict["idagioStartPath"] as! String
    }
    
    var scheme: String {
        return configDict["idagioScheme"] as! String
    }
}

final class YoutubeConfiguration: Configuration {
    var host: String {
        return configDict["googleApiHost"] as! String
    }
    
    var startPath: String {
        return configDict["youtubeApiStartPath"] as! String
    }
    
    var scheme: String {
        return configDict["googleApiScheme"] as! String
    }
    
    var apiKey: String? {
        return configDict["youtubeApiKey"] as? String
    }
    
    var apiKeyParameter: String? {
        return configDict["youtubeApiKeyParameter"] as? String
    }
}
