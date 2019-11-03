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
  func didMoveRow(from originIndex: Int, to destinationIndex: Int)
  func didTapAZOrderButton()
  func didTapSyncButton()
  func didUpdateItem(at index: Int, with string: String)
}

protocol ListPresenterOutput: class {
  func reloadDatas()
  func emptyTextField()
  func deleteRowAtIndexPath(_ indexPath: IndexPath)
  func addRow()
  func didMakeSelection(at index: Int)
}

class ListPresenter {
  weak var output: ListPresenterOutput!
  var interactor: ListInteractorInput
  init(interactor: ListInteractorInput) {
    self.interactor = interactor
  }
}

extension ListPresenter: ListPresenterInput {
  func didUpdateItem(at index: Int, with string: String) {
    interactor.updateItem(at: index, with: string)
  }
  
  func didTapSyncButton() {
    interactor.syncToWatch()
  }

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
  
  func didMoveRow(from originIndex: Int, to destinationIndex: Int) {
    interactor.moveItem(from: originIndex, to: destinationIndex)
  }
  
  func didTapAZOrderButton() {
    interactor.makeAlpahabeticalOrder()
  }
}

extension ListPresenter: ListInteractorOutput {
  func notifyItemAdded() {
    DispatchQueue.main.async {
      self.output.addRow()
      self.output.emptyTextField()
    }
  }
  
  func notifyItemsUpdated() {
    DispatchQueue.main.async {
      self.output.emptyTextField()
      self.output.reloadDatas()
    }
  }
  
  func notifyItemDeleted(at index: Int) {
    DispatchQueue.main.async {
      let indexPath = IndexPath(row: index, section: 0)
      self.output.deleteRowAtIndexPath(indexPath)
    }
  }
  
  func notifyItemSelected(at index: Int) {
    DispatchQueue.main.async {
      self.output.didMakeSelection(at: index)
    }
  }
}
