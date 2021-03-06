//
//  ComposerVideosLoader.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/12/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit
import RxFlow
import RxSwift

protocol VideosViewModelProtocol {
    var videos: Variable<[Video]> { get }
    var errorSubject: PublishSubject<String> { get }
    var progressSubject: PublishSubject<Bool> { get }
    var imagesLoader: ImagesLoaderServiceProtocol { get }
    
    func loadNextPage()
    func selectVideo(at index: Int)
}

class VideosViewModel: VideosViewModelProtocol {
    private let composer: Composer
    private let videosService: VideoSearchServiceProtocol
    private var pageToken: String?
    
    let videos = Variable<[Video]>([])
    let errorSubject = PublishSubject<String>()
    let progressSubject = PublishSubject<Bool>()
    let imagesLoader: ImagesLoaderServiceProtocol
    
    init(videosService: VideoSearchServiceProtocol, imagesLoader: ImagesLoaderServiceProtocol, composer: Composer) {
        self.videosService = videosService
        self.imagesLoader = imagesLoader
        self.composer = composer
    }

    func loadNextPage() {
        progressSubject.onNext(true)
        
        videosService.searchVideos(composer.name!, portionSize: 20, pageToken: pageToken) { [weak self] videos, pageToken, error in
            defer { self?.progressSubject.onNext(false) }
            guard let strongSelf = self else { return }
            
            guard let videos = videos, error == nil else {
                strongSelf.errorSubject.onNext(SearchError.noResults.localizedDescription)
                return
            }
            
            strongSelf.pageToken = pageToken
            strongSelf.videos.value.append(contentsOf: videos)
       }
    }
    
    func selectVideo(at index: Int) {
        step.accept(AppStep.playback(composer: composer, videos: videos.value, initialIndex: index))
    }
}

extension VideosViewModel: Stepper { }
