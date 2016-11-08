//
//  Composer.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/8/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import Foundation

final class Composer: ResponseObjectSerializable, ResponseCollectionSerializable, CustomStringConvertible {
    
    init?(response: HTTPURLResponse, representation: Any) {
        print("s");
    }

    var description: String {
        return "I'm Composer"
    }
}
