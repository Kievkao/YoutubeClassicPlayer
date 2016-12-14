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
    private let storageManager = StorageManager()

    weak var dataConsumer: ComposersDataConsumer?

    func loadComposers() {

        let cachedComposers = storageManager.retrieveObjects(type: ComposerRealm.self)

        if cachedComposers.count > 0 {
            processRetrievedObjects(objects: cachedComposers)
        }
        else {
            loadComposersFromNetwork()
        }
    }

    private func loadComposersFromNetwork() {
        networkManager.loadComsposersWithCompletion { [weak self] (composers, error) in
            guard let strongSelf = self else {
                return
            }

            guard let composers = composers else {
                return
            }

            if strongSelf.storageManager.saveObjects(composers) != nil {
                print("Realm save operation error")
            }

            strongSelf.processRetrievedObjects(objects: composers)
        }
    }

    private func processRetrievedObjects(objects: [ComposerRealm]) {
        var plainComposers = [Composer]()

        for realmObj in objects {
            plainComposers.append(realmObj.plain())
        }

        dataConsumer?.composersDidLoad(composers: plainComposers)
    }
}
