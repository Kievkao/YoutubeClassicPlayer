//
//  ComposersFlow.swift
//  ClassicalPlayer
//
//  Created by Andrii Kravchenko on 06.02.18.
//  Copyright © 2018 Kievkao. All rights reserved.
//

import RxFlow
import RxSwift

//class ComposersFlow: Flow {
//    var root: UIViewController {
//        return self.rootViewController
//    }
//
//    private let rootViewController: UINavigationController
//
//    init(with service: MoviesService) {
//        self.rootViewController = UINavigationController()
//        self.rootViewController.setNavigationBarHidden(true, animated: false)
//        self.service = service
//    }
//
//    func navigate(to step: Step) -> NextFlowItems {
//        guard let step = step as? DemoStep else { return NextFlowItems.stepNotHandled }
//
//        switch step {
//        case .apiKey:
//            return navigationToApiScreen()
//        case .apiKeyIsComplete:
//            return navigationToDashboardScreen()
//        default:
//            return NextFlowItems.stepNotHandled
//        }
//    }
//}

