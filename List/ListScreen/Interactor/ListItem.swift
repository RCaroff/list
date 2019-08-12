//
//  ListItem.swift
//  List
//
//  Created by Rémi Caroff on 21/01/2019.
//  Copyright © 2019 Rémi Caroff. All rights reserved.
//

import Foundation

protocol ListItemProtocol: Codable {
  var label: String { get }
  var isSelected: Bool { get set }
}

class ListItem: ListItemProtocol, WatchSessionMessageItem {
  var label: String
  var isSelected: Bool
  
  init(withLabel label: String) {
    self.label = label
    isSelected = false
  }
}
