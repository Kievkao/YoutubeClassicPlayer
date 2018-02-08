//
//  ComposersFlow.swift
//  ClassicalPlayer
//
//  Created by Andrii Kravchenko on 06.02.18.
//  Copyright © 2018 Kievkao. All rights reserved.
//

import RxFlow
import RxSwift

class ComposersFlow: Flow {
    var root: UIViewController {
        return self.rootViewController
    }

    private let rootViewController: UINavigationController
    private let networkServicesFactory: NetworkServiceFactoryProtocol

    init(networkServicesFactory: NetworkServiceFactoryProtocol) {
        self.networkServicesFactory = networkServicesFactory
        self.rootViewController = UINavigationController()
    }

    func navigate(to step: Step) -> NextFlowItems {
        guard let step = step as? AppStep else { return NextFlowItems.stepNotHandled }

        switch step {
        case .composers:
            return navigationToComposersScreen()
        case .videos(let composer):
            return startVideosFlow(composer: composer)
        default:
            return NextFlowItems.stepNotHandled
        }
    }
    
    private func navigationToComposersScreen() -> NextFlowItems {
        let composersViewController = ComposersViewController.instantiate()
        let viewModel = ComposersViewModel(composersService: networkServicesFactory.composersService())
        composersViewController.viewModel = viewModel
        
        rootViewController.pushViewController(composersViewController, animated: false)
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: composersViewController, nextStepper: viewModel))
    }
    
    private func startVideosFlow(composer: Composer) -> NextFlowItems {
        let videosFlow = VideosFlow(rootViewController: rootViewController, networkServicesFactory: networkServicesFactory)

        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: videosFlow, nextStepper: OneStepper(withSingleStep: AppStep.videos(composer: composer))))
    }
}
