//
//  VideosFlow.swift
//  ClassicalPlayer
//
//  Created by Andrii Kravchenko on 08.02.18.
//  Copyright © 2018 Kievkao. All rights reserved.
//

import UIKit
import RxFlow
import RxSwift

class VideosFlow: Flow {
    var root: UIViewController {
        return self.rootViewController
    }
    
    private let rootViewController: UINavigationController
    private let networkServicesFactory: NetworkServiceFactoryProtocol
    
    init(rootViewController: UINavigationController, networkServicesFactory: NetworkServiceFactoryProtocol) {
        self.networkServicesFactory = networkServicesFactory
        self.rootViewController = rootViewController
    }

    func navigate(to step: Step) -> NextFlowItems {
        guard let step = step as? AppStep else { return NextFlowItems.stepNotHandled }
        
        switch step {
        case .videos(let composer):
            return navigationToVideosScreen(composer: composer)
        case .playback(let composer, let videos, let initialIndex):
            return navigationToPlaybackScreen(composer: composer, videos: videos, initialIndex: initialIndex)
        default:
            return NextFlowItems.stepNotHandled
        }
    }
    
    private func navigationToVideosScreen(composer: Composer) -> NextFlowItems {
        let videosViewController = VideosViewController.instantiate()
        let viewModel = VideosViewModel(videosService: networkServicesFactory.videoSearchService(), imagesLoader: networkServicesFactory.imagesLoaderService(), composer: composer)
        videosViewController.viewModel = viewModel
        
        rootViewController.pushViewController(videosViewController, animated: true)
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: videosViewController, nextStepper: viewModel))
    }
    
    private func navigationToPlaybackScreen(composer: Composer, videos: [Video], initialIndex: Int) -> NextFlowItems {
        let playbackViewController = PlaybackViewController.instantiate()
        let viewModel = PlaybackViewModel(composer: composer, videos: videos, currentIndex: initialIndex)
        playbackViewController.viewModel = viewModel
        
        rootViewController.pushViewController(playbackViewController, animated: true)
        return NextFlowItems.none
    }
}
