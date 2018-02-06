//
//  Composer.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/8/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import Foundation

struct Composer {
    let forename: String?
    let surname: String?
    let name: String?
    
    init(json: [String: AnyObject]) {
        forename = json["forename"] as? String
        surname = json["surname"] as? String
        name = json["name"] as? String
    }
}
