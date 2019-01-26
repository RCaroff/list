//
//  ListRepository.swift
//  List
//
//  Created by Rémi Caroff on 21/01/2019.
//  Copyright © 2019 Rémi Caroff. All rights reserved.
//

import Foundation

protocol ListRepositoryProtocol: class {
  func get() throws -> [ListItemDataModel]
  func save(dataModels: [ListItemDataModel]) throws
  func clear() throws
}

class ListRepository: ListRepositoryProtocol {
  
  enum Constant {
    static let listKey = "listKey"
  }
  
  var storage: Storage
  
  init(with storage: Storage) {
    self.storage = storage
  }
  
  func get() throws -> [ListItemDataModel] {
    return try storage.get(key: Constant.listKey)
  }
  
  func save(dataModels: [ListItemDataModel]) throws {
    try storage.set(object: dataModels, forKey: Constant.listKey)
  }
  
  func clear() throws {
    try storage.delete(key: Constant.listKey)
  }
}
