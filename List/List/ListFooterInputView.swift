//
//  ListFooterInputView.swift
//  List
//
//  Created by Rémi Caroff on 23/01/2019.
//  Copyright © 2019 Rémi Caroff. All rights reserved.
//

import UIKit

protocol ListFooterInputViewDelegate: class {
  func didInputText(_ text: String)
}

class ListFooterInputView: UIView {
  @IBOutlet private var textField: UITextField!
  @IBOutlet private var enterButton: UIButton!
  
  weak var delegate: ListFooterInputViewDelegate?
  
  @IBAction func didTapEnterButton() {
    guard let text = textField.text, !text.isEmpty else { return }
    delegate?.didInputText(text)
  }
  
  func clearTextField() {
    textField.text = ""
  }
}

extension ListFooterInputView: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    didTapEnterButton()
    return true
  }
}
