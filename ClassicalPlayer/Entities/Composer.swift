//
//  Composer.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/8/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import Foundation
import RealmSwift

class ComposerRealm: Object {
    @objc dynamic var forename: String = ""
    @objc dynamic var surname: String = ""
    @objc dynamic var name: String = ""

    func plain() -> Composer {
        return Composer(forename: forename, surname: surname, name: name)
    }
}

struct Composer {
    let forename: String?
    let surname: String?
    let name: String?
    
    init(json: [String: AnyObject]) {
        forename = json["forename"] as? String
        surname = json["surname"] as? String
        name = json["name"] as? String
    }
    
    init(forename: String?, surname: String?, name: String?) {
        self.forename = forename
        self.surname = surname
        self.name = name
    }
}
