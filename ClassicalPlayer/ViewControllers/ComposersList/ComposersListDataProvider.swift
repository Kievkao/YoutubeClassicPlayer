//
//  ComposersListDataProvider.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/12/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import Foundation

class ComposersListDataProvider {

    private let networkManager = NetworkManager()

    weak var dataConsumer: ComposersViewController?

    func loadComposers() {
        networkManager.loadComsposersWithCompletion { [weak self] (composers, error) in
            guard let strongSelf = self else {
                return
            }

            strongSelf.dataConsumer?.composersDidLoad(composers: composers ?? [])
        }
    }
}
