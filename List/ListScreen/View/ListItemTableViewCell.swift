//
//  ItemTableViewCell.swift
//  List
//
//  Created by Rémi Caroff on 18/08/2019.
//  Copyright © 2019 Rémi Caroff. All rights reserved.
//

import UIKit

class ListItemTableViewCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var checkmarkImageView: UIImageView?
  
    func setContent(with viewModel: ListItemViewModelProtocol) {
        titleLabel?.text = viewModel.label
        checkmarkImageView?.isHidden = !viewModel.showCheckmark
    }
    
}
