//
//  StoryboardBased.swift
//  ClassicalPlayer
//
//  Created by Andrii Kravchenko on 06.02.18.
//  Copyright © 2018 Kievkao. All rights reserved.
//

import UIKit

protocol StoryboardBased where Self: UIViewController {
    static func instantiate() -> Self
}
