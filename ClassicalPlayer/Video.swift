//
//  Video.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/7/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import Foundation

final class Video: ResponseObjectSerializable, ResponseCollectionSerializable, CustomStringConvertible {

    init?(response: HTTPURLResponse, representation: Any) {
        print("s");
    }

    var description: String {
        return "I'm video"
    }
}
