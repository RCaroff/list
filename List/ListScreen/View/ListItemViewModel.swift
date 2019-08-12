//
//  ListItemViewModel.swift
//  List
//
//  Created by Rémi Caroff on 21/01/2019.
//  Copyright © 2019 Rémi Caroff. All rights reserved.
//

import Foundation

protocol ListItemViewModelProtocol {
  var label: String { get }
  var showCheckmark: Bool { get }
}

struct ListItemViewModel: ListItemViewModelProtocol {
  var label: String
  var showCheckmark: Bool
}
