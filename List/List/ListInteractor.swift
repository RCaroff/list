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
}

protocol ListInteractorOutput: class {
  func notifyItemsUpdated()
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
    
  }
  
  func addItem(with string: String) {
    let item = ListItem(withLabel: string)
    items.append(item)
    output?.notifyItemsUpdated()
  }
  
  func deleteItem(at index: Int) {
    items.remove(at: index)
    output?.notifyItemsUpdated()
  }
  
  func selectItem(at index: Int) {
    items[index].isSelected = !items[index].isSelected
    output?.notifyItemsUpdated()
  }
}
