//
//  AppCoordinator.swift
//  ClassicalPlayer
//
//  Created by Andrii Kravchenko on 06.02.18.
//  Copyright © 2018 Kievkao. All rights reserved.
//

import UIKit
import AVFoundation
import RxFlow
import RxSwift
import RxCocoa

class AppCoordinator {
    private let disposeBag = DisposeBag()
    private let coordinator = Coordinator()
    private let networkFactory = NetworkServiceFactory()
    
    private lazy var initialFlow = {
        return ComposersFlow(networkServicesFactory: networkFactory)
    }()
    
    func start(inWindow window: UIWindow) {
        setupAudioSession()
        
        coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            print ("did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        
        Flows.whenReady(flow1: initialFlow, block: { [unowned window] root in
            window.rootViewController = root
        })
        
        coordinator.coordinate(flow: initialFlow, withStepper: OneStepper(withSingleStep: AppStep.composers))
    }
    
    private func setupAudioSession() {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
    }
}
