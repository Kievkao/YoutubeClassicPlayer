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
    dynamic var forename: String = ""
    dynamic var surname: String = ""
    dynamic var name: String = ""

    func plain() -> Composer {
        return Composer(forename: forename, surname: surname, name: name)
    }
}

struct Composer {
    let forename: String
    let surname: String
    let name: String
}
