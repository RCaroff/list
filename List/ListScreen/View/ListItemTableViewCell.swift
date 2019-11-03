//
//  ItemTableViewCell.swift
//  List
//
//  Created by Rémi Caroff on 18/08/2019.
//  Copyright © 2019 Rémi Caroff. All rights reserved.
//

import UIKit

protocol ListItemTableViewCellDelegate: class {
  func listItemCell(_ cell: ListItemTableViewCell, shouldStartEditingAt indexPath: IndexPath) -> Bool
  func listItemCell(_ cell: ListItemTableViewCell, didStartEditingAt indexPath: IndexPath)
  func listItemCell(_ cell: ListItemTableViewCell, didFinishEditingWithText text: String, at indexPath: IndexPath)
}

class ListItemTableViewCell: UITableViewCell {
  @IBOutlet private weak var titleLabel: UILabel?
  @IBOutlet private weak var editingTextField: UITextField?
  @IBOutlet private weak var checkmarkImageView: UIImageView?
  private var longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
  
  private var indexPath: IndexPath?
  private weak var delegate: ListItemTableViewCellDelegate?
  private var isItemEditing: Bool {
    return editingTextField?.isEditing ?? false
  }
  
  func setContent(with viewModel: ListItemViewModelProtocol, at indexPath: IndexPath, delegate: ListItemTableViewCellDelegate) {
    self.indexPath = indexPath
    self.delegate = delegate
    editingTextField?.isHidden = true
    titleLabel?.isHidden = false
    titleLabel?.text = viewModel.label
    checkmarkImageView?.isHidden = !viewModel.showCheckmark
    setupLongPress()
  }
  
  private func setupLongPress() {
    longPress.addTarget(self, action: #selector(longPressed(_:)))
    contentView.addGestureRecognizer(longPress)
  }
  
  @objc private func longPressed(_ gesture: UILongPressGestureRecognizer) {
    guard let indexPath = indexPath else { return }
    guard delegate?.listItemCell(self, shouldStartEditingAt: indexPath) == true else { return }
    guard !isItemEditing else { return }
    editingTextField?.text = titleLabel?.text
    titleLabel?.isHidden = true
    editingTextField?.isHidden = false
    editingTextField?.becomeFirstResponder()
    delegate?.listItemCell(self, didStartEditingAt: indexPath)
  }
}

extension ListItemTableViewCell: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let text = textField.text else { return }
    guard let indexPath = self.indexPath else { return }
    titleLabel?.text = text
    editingTextField?.isHidden = true
    titleLabel?.isHidden = false
    delegate?.listItemCell(self, didFinishEditingWithText: text, at: indexPath)
  }
}

extension ListItemTableViewCellDelegate {
  func listItemCell(_ cell: ListItemTableViewCell, shouldStartEditingAt indexPath: IndexPath) -> Bool {
    return true
  }
}
