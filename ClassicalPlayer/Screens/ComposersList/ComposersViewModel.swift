//
//  ComposersDataProvider.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/12/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import Foundation
import RxFlow
import RxSwift

protocol ComposersViewModelProtocol {
    var composers: Variable<[Composer]> { get }
    var errorSubject: PublishSubject<String> { get }
    var progressSubject: PublishSubject<Bool> { get }

    func loadComposers()
    func selectComposer(_ composer: Composer)
}

enum SearchError: Error {
    case noResults
    case noInternet
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .noResults: return "No Results".localized()
        case .noInternet: return "No Internet connection".localized()
        case .unknownError: return "Unknown Error".localized()
        }
    }
}

class ComposersViewModel: ComposersViewModelProtocol {
    private let composersService: ComposersServiceProtocol
    
    let composers = Variable<[Composer]>([])
    let errorSubject = PublishSubject<String>()
    let progressSubject = PublishSubject<Bool>()
    
    init(composersService: ComposersServiceProtocol) {
        self.composersService = composersService
    }

    func loadComposers() {
        progressSubject.onNext(true)
        
        composersService.loadComposers { [weak self] (composers, error) in
            defer { self?.progressSubject.onNext(false) }
            guard let strongSelf = self else { return }
            
            guard let composers = composers, error == nil else {
                strongSelf.errorSubject.onNext(SearchError.noResults.localizedDescription)
                return
            }
            
            strongSelf.composers.value = composers
        }
    }
    
    func selectComposer(_ composer: Composer) {
        step.accept(AppStep.videos(composer: composer))
    }
}

extension ComposersViewModel: Stepper { }
