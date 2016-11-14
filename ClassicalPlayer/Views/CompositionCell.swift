//
//  CompositionCell.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/8/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit

class CompositionCell: UITableViewCell {

    @IBOutlet weak private var thumbnailImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!

    func setThumbnail(image: UIImage) {
        thumbnailImageView.image = image
    }

    func setName(name: String) {
        nameLabel.text = name
    }
}
