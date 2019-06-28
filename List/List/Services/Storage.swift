//
//  Storage.swift
//  List
//
//  Created by Rémi Caroff on 21/01/2019.
//  Copyright © 2019 Rémi Caroff. All rights reserved.
//

import Foundation

protocol Storage: class {
  func get<T: Decodable>(key: String) throws -> T
  func delete(key: String) throws
  func set<T: Encodable>(object: T, forKey key: String) throws
}

enum StorageError: Error {
  case noDataForKey(key: String)
  case unknown
}

class UserDefaultsStorage: Storage {
  
  private let userDefaults = UserDefaults(suiteName: "group.rcaroff.list") ?? UserDefaults.standard

  func get<T: Decodable>(key: String) throws -> T {
    guard let object = userDefaults.data(forKey: key) else {
      throw StorageError.noDataForKey(key: key)
    }
    
    return try JSONDecoder().decode(T.self, from: object)
  }
  
  func delete(key: String) throws {
    userDefaults.set(nil, forKey: key)
    userDefaults.synchronize()
  }
  
  func set<T: Encodable>(object: T, forKey key: String) throws {
    let data = try JSONEncoder().encode(object)
    userDefaults.set(data, forKey: key)
    userDefaults.synchronize()
  }
}
