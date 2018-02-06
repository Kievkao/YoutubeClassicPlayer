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
    private let service: ComposersServiceProtocol

    init(service: ComposersServiceProtocol) {
        self.service = service
        self.rootViewController = UINavigationController()
    }

    func navigate(to step: Step) -> NextFlowItems {
        guard let step = step as? AppStep else { return NextFlowItems.stepNotHandled }

        switch step {
        case .composers:
            return navigationToComposersScreen()
        }
    }
    
    private func navigationToComposersScreen () -> NextFlowItems {
        let composersViewController = ComposersViewController.instantiate()
        composersViewController.viewModel = ComposersViewModel(composersService: service)
        
        rootViewController.pushViewController(composersViewController, animated: false)
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: composersViewController, nextStepper: composersViewController))
    }
}
