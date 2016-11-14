//
//  ComposerCell.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/8/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit

class ComposerCell: UITableViewCell {

    @IBOutlet weak private var nameLabel: UILabel!

    func setComposerName(name: String) {
        nameLabel.text = name
    }
}
