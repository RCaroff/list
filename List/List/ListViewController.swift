//
//  ViewController.swift
//  List
//
//  Created by Rémi Caroff on 21/01/2019.
//  Copyright © 2019 Rémi Caroff. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  private var footerInputView: ListFooterInputView?
  
  var presenter: ListPresenterInput!

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter.viewDidLoad()
  }
  
  @IBAction func clearAllButtonTapped() {
    presenter.didTapClearAllButton()
  }
  
  @IBAction func clearDoneButtonTapped() {
    presenter.didTapClearDoneButton()
  }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    guard let view = UINib(nibName: "ListFooterInputView", bundle: nil)
      .instantiate(withOwner: nil, options: nil).first as? ListFooterInputView else { return nil }
    view.delegate = self
    footerInputView = view
    
    return view
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfItems()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
    let vm = presenter.viewModel(at: indexPath.row)
    cell.textLabel?.text = vm?.label
    cell.accessoryType = vm?.showCheckmark ?? false ? .checkmark : .none
    
    return cell
  }
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presenter.didSelectRow(at: indexPath.row)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    switch editingStyle {
    case .delete:
      self.presenter.didTapDelete(at: indexPath.row)
    default:
      return
    }
  }
}

extension ListViewController: ListFooterInputViewDelegate {
  func didInputText(_ text: String) {
    presenter.didEnterNewString(text)
  }
}

// MARK: - ListPresenterOutput
extension ListViewController: ListPresenterOutput {
  
  func addRow() {
    let ip = IndexPath(row: presenter.numberOfItems()-1, section: 0)
    tableView.insertRows(at: [ip], with: .automatic)
    tableView.scrollToRow(at: IndexPath(row: presenter.numberOfItems()-1, section: 0), at: .top, animated: true)
  }
  
  func deleteRowAtIndexPath(_ indexPath: IndexPath) {
    tableView.deleteRows(at: [indexPath], with: .automatic)
  }
  
  func emptyTextField() {
    footerInputView?.clearTextField()
  }
  
  func reloadDatas() {
    tableView.reloadSections([0], with: .automatic)
  }
}
