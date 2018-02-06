//
//  VideoCell.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/8/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit
import RxSwift

class VideoCell: UITableViewCell {
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak private var thumbnailImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    
    var viewModel: VideoCellViewModelProtocol! {
        didSet {
            disposeBag = DisposeBag()
            
            nameLabel.text = viewModel.name
            thumbnailImageView.image = UIImage.placeholder()
            viewModel.loadImage()
            
            viewModel.image.subscribe(onNext: { [weak self] image in
                self?.thumbnailImageView.image = image
            }).disposed(by: disposeBag)
        }
    }
}
