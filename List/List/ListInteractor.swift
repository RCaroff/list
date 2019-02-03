//
//  ListInteractor.swift
//  List
//
//  Created by Rémi Caroff on 21/01/2019.
//  Copyright © 2019 Rémi Caroff. All rights reserved.
//

import Foundation

protocol ListInteractorInput: class {
  func loadItems()
  func numberOfItems() -> Int
  func item(at index: Int) -> ListItemProtocol?
  func addItem(with string: String)
  func deleteItem(at index: Int)
  func selectItem(at index: Int)
  func clearAll()
  func clearDone()
  func saveState()
  func moveItem(from originIndex: Int, to destinationIndex: Int)
  func makeAlpahabeticalOrder()
}

protocol ListInteractorOutput: class {
  func notifyItemsUpdated()
  func notifyItemDeleted(at index: Int)
  func notifyItemAdded()
  func notifyItemSelected(at index: Int)
}

class ListInteractor {
  var repository: ListRepositoryProtocol
  weak var output: ListInteractorOutput?
  
  private var items: [ListItemProtocol] = []
  
  init(repository: ListRepositoryProtocol) {
    self.repository = repository
  }
}

extension ListInteractor: ListInteractorInput {
  
  func makeAlpahabeticalOrder() {
    items.sort { $0.label < $1.label }
    output?.notifyItemsUpdated()
  }
  
  func saveState() {
    let dataModels = items.map { itemProtocol -> ListItemDataModel in
      return ListItemDataModel(label: itemProtocol.label, isSelected: itemProtocol.isSelected)
    }
    do {
      try repository.save(dataModels: dataModels)
    } catch {
      debugPrint("unable to save")
    }
  }

  func loadItems() {
    do {
      let dataModels = try repository.get()
      items = dataModels.map({ dataModel -> ListItemProtocol in
        let item = ListItem(withLabel: dataModel.label)
        item.isSelected = dataModel.isSelected
        
        return item
      })
      
      output?.notifyItemsUpdated()
    } catch {
      debugPrint("no item")
    }
  }
  
  func numberOfItems() -> Int {
    return items.count
  }
  
  func item(at index: Int) -> ListItemProtocol? {
    guard items.count > index else {
      return nil
    }
    return items[index]
  }
  
  func clearAll() {
    try? repository.clear()
    items.removeAll()
    output?.notifyItemsUpdated()
  }
  
  func clearDone() {
    items = items.filter { !$0.isSelected }
    output?.notifyItemsUpdated()
  }
  
  func addItem(with string: String) {
    let item = ListItem(withLabel: string)
    items.append(item)
    output?.notifyItemAdded()
  }
  
  func deleteItem(at index: Int) {
    items.remove(at: index)
    output?.notifyItemDeleted(at: index)
  }
  
  func selectItem(at index: Int) {
    items[index].isSelected = !items[index].isSelected
    output?.notifyItemSelected(at: index)
  }
  
  func moveItem(from originIndex: Int, to destinationIndex: Int) {
    guard originIndex != destinationIndex else { return }
    let item = items[originIndex]
    items.remove(at: originIndex)
    items.insert(item, at: destinationIndex)
  }
}
