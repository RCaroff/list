//
//  WatchSessionMessage.swift
//  List
//
//  Created by Rémi Caroff on 07/04/2019.
//  Copyright © 2019 Rémi Caroff. All rights reserved.
//

import Foundation

enum WatchSessionMessageAction {
  static let add = "WatchSessionMessageActionAdd"
  static let delete = "WatchSessionMessageActionDelete"
  static let select = "WatchSessionMessageActionSelect"
  static let load = "WatchSessionMessageActionLoad"
}

protocol WatchSessionMessageProtocol: Codable {
  var action: String { get }
  var index: Int { get }
  var data: Data? { get }
}

protocol WatchSessionMessageItem: Codable {
  var label: String { get }
  var isSelected: Bool { get set }
}

struct WatchSessionMessage: WatchSessionMessageProtocol {
  var action: String
  var index: Int
  var data: Data?
}
