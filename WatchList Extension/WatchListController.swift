//
//  ListInterfaceController.swift
//  WatchList Extension
//
//  Created by Rémi Caroff on 05/04/2019.
//  Copyright © 2019 Rémi Caroff. All rights reserved.
//

import WatchKit
import Foundation

class WatchListController: WKInterfaceController {
  
  @IBOutlet var tableView: WKInterfaceTable!
  @IBOutlet var placeholderLabel: WKInterfaceLabel!
  
  var presenter: WatchListPresenterInput!
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    let interactor = WatchListInteractorFactory().make()
    let pres = WatchListPresenter(interactor: interactor)
    pres.output = self
    interactor.setOutput(pres)
    presenter = pres
    presenter.awake()
  }
  
  func reloadTable() {
    tableView.setNumberOfRows(presenter.numberOfRows(), withRowType: "ListRowIdentifier")
    for i in 0..<presenter.numberOfRows() {
      guard let vm = presenter.itemForRow(i) else { return }
      guard let controller = tableView.rowController(at: i) as? WatchListTableRowController else { return }
      controller.viewModel = vm
    }
  }
  
  override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
    super.table(table, didSelectRowAt: rowIndex)
    presenter.didSelectRow(at: rowIndex)
  }
}

// MARK: - WatchListPresenterOutput

extension WatchListController: WatchListPresenterOutput {

  func showTable(_ show: Bool) {
    tableView.setHidden(!show)
  }
  
  func showPlaceholder(_ show: Bool, with text: String? = nil) {
    placeholderLabel.setText(text)
    placeholderLabel.setHidden(!show)
  }

  func setRow(viewModel: WatchListItemViewModel, at index: Int) {
    guard let row = tableView.rowController(at: index) as? WatchListTableRowController else { return }
    row.viewModel = viewModel
  }
  
  func reloadData() {
    reloadTable()
  }
  
  func deleteRow(_ row: Int) {
    tableView.removeRows(at: [row])
  }
  
  func addRow(viewModel: WatchListItemViewModel, at index: Int) {
    tableView.insertRows(at: [index], withRowType: "ListRowIdentifier")
    guard let controller = tableView.rowController(at: index) as? WatchListTableRowController else { return }
    controller.viewModel = viewModel
  }
}
