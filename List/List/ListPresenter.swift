//
//  ListPresenter.swift
//  List
//
//  Created by Rémi Caroff on 21/01/2019.
//  Copyright © 2019 Rémi Caroff. All rights reserved.
//

import Foundation

protocol ListPresenterInput: class {
  func viewDidLoad()
  func viewModel(at index: Int) -> ListItemViewModelProtocol?
  func numberOfItems() -> Int
  func didSelectRow(at index: Int)
  func didTapClearAllButton()
  func didTapClearDoneButton()
  func didEnterNewString(_ label: String)
  func didTapDelete(at index: Int)
}

protocol ListPresenterOutput: class {
  func reloadDatas()
  func emptyTextField()
  func deleteRowAtIndexPath(_ indexPath: IndexPath)
}

class ListPresenter {
  weak var output: ListPresenterOutput!
  var interactor: ListInteractorInput
  init(interactor: ListInteractorInput) {
    self.interactor = interactor
  }
}

extension ListPresenter: ListPresenterInput {

  func viewDidLoad() {
    interactor.loadItems()
  }
  
  func numberOfItems() -> Int {
    return interactor.numberOfItems()
  }
  
  func viewModel(at index: Int) -> ListItemViewModelProtocol? {
    return interactor.item(at: index).map({ item -> ListItemViewModelProtocol in
      return ListItemViewModel(label: item.label, showCheckmark: item.isSelected)
    })
  }
  
  func didSelectRow(at index: Int) {
    interactor.selectItem(at: index)
  }
  
  func didTapClearAllButton() {
    interactor.clearAll()
  }
  
  func didTapClearDoneButton() {
    interactor.clearDone()
  }
  
  func didEnterNewString(_ label: String) {
    interactor.addItem(with: label)
  }
  
  func didTapDelete(at index: Int) {
    interactor.deleteItem(at: index)
  }
}

extension ListPresenter: ListInteractorOutput {
  func notifyItemsUpdated() {
    output.emptyTextField()
    output.reloadDatas()
  }
  
  func notifyItemDeleted(at index: Int) {
    let indexPath = IndexPath(row: index, section: 0)
    output.deleteRowAtIndexPath(indexPath)
  }
}
