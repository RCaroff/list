//
//  WatchListInteractorFactory.swift
//  WatchList Extension
//
//  Created by Rémi Caroff on 22/04/2019.
//  Copyright © 2019 Rémi Caroff. All rights reserved.
//

import Foundation

protocol WatchListInteractorFactoryProtocol {
  func make() -> WatchListInteractorInput
}

final class WatchListInteractorFactory: WatchListInteractorFactoryProtocol {
  func make() -> WatchListInteractorInput {
    let storage = UserDefaultsStorage()
    let repo = ListRepository(with: storage)
    let watchSessionManager = WatchSessionManager.shared
    let interactor = WatchListInteractor(repository: repo)
    watchSessionManager.setWatchOutput(interactor)
    interactor.watchSessionManager = watchSessionManager
    
    return interactor
  }
}
