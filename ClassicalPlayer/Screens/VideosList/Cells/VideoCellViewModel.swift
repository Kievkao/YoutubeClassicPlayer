//
//  VideoCellViewModel.swift
//  ClassicalPlayer
//
//  Created by Andrii Kravchenko on 08.02.18.
//  Copyright © 2018 Kievkao. All rights reserved.
//

import UIKit
import RxSwift

protocol VideoCellViewModelProtocol {
    var name: String? { get }
    var image: Observable<UIImage?> { get }
    
    func loadImage()
    func cancelImageLoading()
}

class VideoCellViewModel: VideoCellViewModelProtocol {
    private let video: Video
    private let imagesLoader: ImagesLoaderServiceProtocol
    
    var name: String? { return video.title }
    var image: Observable<UIImage?> { return imageVariable.asObservable() }
    private let imageVariable = Variable<UIImage?>(nil)
    
    init(imagesLoader: ImagesLoaderServiceProtocol, video: Video) {
        self.imagesLoader = imagesLoader
        self.video = video
    }
    
    func loadImage() {
        guard let imageURL = video.thumbnailURL else { return }
        
        imagesLoader.loadImageFor(imageURL: imageURL) { [weak self] image in
            self?.imageVariable.value = image
        }
    }
    
    func cancelImageLoading() {
        if let imageURL = video.thumbnailURL {
            imagesLoader.cancelImageLoadingFor(imageURL: imageURL)
        }
    }
}
