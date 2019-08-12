//
//  ListInteractorFactory.swift
//  List
//
//  Created by Rémi Caroff on 06/04/2019.
//  Copyright © 2019 Rémi Caroff. All rights reserved.
//

import Foundation

protocol ListInteractorFactoryProtocol {
  func make() -> ListInteractorInput
}

class ListInteractorFactory: ListInteractorFactoryProtocol {
  func make() -> ListInteractorInput {
    let storage = UserDefaultsStorage()
    let repo = ListRepository(with: storage)
    let watchSessionManager = WatchSessionManager.shared
    let interactor = ListInteractor(repository: repo)
    watchSessionManager.setAppOutput(interactor)
    interactor.watchSessionManager = watchSessionManager
    
    return interactor
  }
}
