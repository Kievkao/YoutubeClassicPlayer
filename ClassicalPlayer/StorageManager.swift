//
//  StorageManager.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 12/13/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import Foundation
import RealmSwift

class StorageManager {
    static private let realm = try! Realm()

    func saveObjects(_ objects: [Object]) -> Error? {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(objects)
            }
        } catch let error {
            return error
        }

        return nil
    }

    func retrieveObjects<T:Object>(type: T.Type) -> [T] {
        let realm = try! Realm()
        let results = realm.objects(type)
        var unwiredObjects = [T]()

        for object in results {
            unwiredObjects.append(object)
        }
        
        return unwiredObjects
    }
}
