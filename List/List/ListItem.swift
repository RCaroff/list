//
//  ListItem.swift
//  List
//
//  Created by Rémi Caroff on 21/01/2019.
//  Copyright © 2019 Rémi Caroff. All rights reserved.
//

import Foundation

protocol ListItemProtocol {
  var label: String { get }
  var isSelected: Bool { get set }
}

class ListItem: ListItemProtocol {
  var label: String
  var isSelected: Bool
  
  init(withLabel label: String) {
    self.label = label
    isSelected = false
  }
}
