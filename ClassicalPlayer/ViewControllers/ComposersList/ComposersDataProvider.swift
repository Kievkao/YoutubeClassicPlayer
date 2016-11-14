//
//  ComposersDataProvider.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/12/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import Foundation

protocol ComposersDataConsumer: class {
    func composersDidLoad(composers: [Composer])
}

class ComposersDataProvider {

    private let networkManager = NetworkManager()
    weak var dataConsumer: ComposersDataConsumer?

    func loadComposers() {
        networkManager.loadComsposersWithCompletion { [weak self] (composers, error) in
            guard let strongSelf = self else {
                return
            }

            strongSelf.dataConsumer?.composersDidLoad(composers: composers ?? [])
        }
    }
}
