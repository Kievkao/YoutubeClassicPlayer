//
//  AppDelegate.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/7/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit
import AVFoundation
import RxFlow
import RxSwift
import RxCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let disposeBag = DisposeBag()
    private let coordinator = Coordinator()
    private let networkFactory = NetworkServiceFactory()
    
    private lazy var composersFlow = {
        return ComposersFlow(service: networkFactory.composersService())
    }()
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        
        guard let window = self.window else { return false }
        
        coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            print ("did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        
        Flows.whenReady(flow1: composersFlow, block: { [unowned window] (root) in
            window.rootViewController = root
        })
        
        coordinator.coordinate(flow: composersFlow, withStepper: OneStepper(withSingleStep: AppStep.composers))
        return true
    }
}
