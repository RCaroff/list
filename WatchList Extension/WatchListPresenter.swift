//
//  ListInterfacePresenter.swift
//  WatchList Extension
//
//  Created by Rémi Caroff on 05/04/2019.
//  Copyright © 2019 Rémi Caroff. All rights reserved.
//

import Foundation

protocol WatchListPresenterInput {
  func awake()
  func itemForRow(_ row: Int) -> WatchListItemViewModel?
  func numberOfRows() -> Int
  func didSelectRow(at index: Int)
}

protocol WatchListPresenterOutput: class {
  func reloadData()
  func deleteRow(_ row: Int)
  func addRow(viewModel: WatchListItemViewModel, at index: Int)
  func setRow(viewModel: WatchListItemViewModel, at index: Int)
  func showTable(_ show: Bool)
  func showPlaceholder(_ show: Bool, with text: String?)
}

class WatchListPresenter {
  weak var output: WatchListPresenterOutput?
  private var interactor: WatchListInteractorInput
  
  init(interactor: WatchListInteractorInput) {
    self.interactor = interactor
  }
}

extension WatchListPresenter: WatchListPresenterInput {
  
  func awake() {
    interactor.activateSession()
  }
  
  func numberOfRows() -> Int {
    return interactor.numberOfItems()
  }
  
  func itemForRow(_ row: Int) -> WatchListItemViewModel? {
    guard let item = interactor.item(atIndex: row) else { return nil }
    return WatchListItemViewModel(title: item.label, hasCheckmark: item.isSelected)
  }
  
  func didSelectRow(at index: Int) {
    interactor.didSelectItem(at: index)
  }
}

extension WatchListPresenter: WatchListInteractorOutput {
  
  func notifyItemsListIsEmpty(_ empty: Bool) {
    DispatchQueue.main.async {
      self.output?.showTable(!empty)
      self.output?.showPlaceholder(empty, with:
        """
        Start by adding elements on the iPhone app !
        
        📲
        """
      )
    }
  }
  
  func notifyItemSelected(item: ListItemProtocol, at index: Int) {
    DispatchQueue.main.async {
      let viewModel = WatchListItemViewModel(title: item.label, hasCheckmark: item.isSelected)
      self.output?.setRow(viewModel: viewModel, at: index)
    }
  }

  func notifyItemsUpdated() {
    DispatchQueue.main.async {
      self.output?.reloadData()
    }
  }
  
  func notifyItemDeleted(at index: Int) {
    DispatchQueue.main.async {
      self.output?.deleteRow(index)
    }
  }
  
  func notifyItemAdded(item: ListItemProtocol, at index: Int) {
    DispatchQueue.main.async {
      let viewModel = WatchListItemViewModel(title: item.label, hasCheckmark: item.isSelected)
      self.output?.addRow(viewModel: viewModel, at: index)
    }
  }
}
