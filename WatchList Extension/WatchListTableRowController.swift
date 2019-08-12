//
//  ListInterfaceTableRowController.swift
//  WatchList Extension
//
//  Created by Rémi Caroff on 05/04/2019.
//  Copyright © 2019 Rémi Caroff. All rights reserved.
//

import WatchKit

class WatchListTableRowController: NSObject {
  
  @IBOutlet private var titleLabel: WKInterfaceLabel!
  @IBOutlet private var checkmarkImage: WKInterfaceImage!
  
  var viewModel: WatchListItemViewModel! {
    didSet {
      titleLabel.setText(viewModel.title)
      checkmarkImage.setHidden(!viewModel.hasCheckmark)
    }
  }
}
