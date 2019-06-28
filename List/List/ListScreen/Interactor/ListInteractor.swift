//
//  ListInteractor.swift
//  List
//
//  Created by Rémi Caroff on 21/01/2019.
//  Copyright © 2019 Rémi Caroff. All rights reserved.
//

import Foundation

protocol ListInteractorInput: class {
  func setOutput(_ output: ListInteractorOutput)
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
  func syncToWatch()
}

protocol ListInteractorOutput: class {
  func notifyItemsUpdated()
  func notifyItemDeleted(at index: Int)
  func notifyItemAdded()
  func notifyItemSelected(at index: Int)
}

class ListInteractor {
  private var repository: ListRepositoryProtocol
  var watchSessionManager: WatchSessionManagerInput! {
    didSet {
      watchSessionManager.startSession()
    }
  }
  
  weak var output: ListInteractorOutput?
  
  private var items: [ListItem] = []
  
  init(repository: ListRepositoryProtocol) {
    self.repository = repository
  }
  
  private func addToWatch(item: ListItem) {
    guard let data = try? JSONEncoder().encode(item) else { return }
    let message = WatchSessionMessage(action: WatchSessionMessageAction.add, index: items.count-1, data: data)
    do {
      try watchSessionManager.send(message: message)
    } catch (let error) {
      print("error sending message: \(error.localizedDescription)")
    }
  }
  
  private func selectToWatch(item: ListItem, at index: Int) {
    guard let data = try? JSONEncoder().encode(item) else { return }
    let message = WatchSessionMessage(action: WatchSessionMessageAction.select, index: index, data: data)
    do {
      try watchSessionManager.send(message: message)
    } catch (let error) {
      print("error sending message: \(error.localizedDescription)")
    }
  }
  
  private func loadToWatch(items: [ListItem]) {
    guard let data = try? JSONEncoder().encode(items) else { return }
    let message = WatchSessionMessage(action: WatchSessionMessageAction.load, index: 0, data: data)
    do {
      try watchSessionManager.send(message: message)
    } catch (let error) {
      print("error sending message: \(error.localizedDescription)")
    }
  }
  
  private func deleteToWatch(index: Int) {
    let message = WatchSessionMessage(action: WatchSessionMessageAction.delete, index: index, data: nil)
    do {
      try watchSessionManager.send(message: message)
    } catch (let error) {
      print("error sending message: \(error.localizedDescription)")
    }
  }
}

extension ListInteractor: ListInteractorInput {
  func setOutput(_ output: ListInteractorOutput) {
    self.output = output
  }

  func makeAlpahabeticalOrder() {
    items.sort { $0.label.sanitized() < $1.label.sanitized() }
    saveState()
    loadToWatch(items: items)
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
      items = dataModels.map({ dataModel -> ListItem in
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
    saveState()
    loadToWatch(items: items)
    output?.notifyItemsUpdated()
  }
  
  func clearDone() {
    items = items.filter { !$0.isSelected }
    saveState()
    loadToWatch(items: items)
    output?.notifyItemsUpdated()
  }
  
  func addItem(with string: String) {
    let item = ListItem(withLabel: string)
    items.append(item)
    saveState()
    output?.notifyItemAdded()
    addToWatch(item: item)
  }
  
  func deleteItem(at index: Int) {
    items.remove(at: index)
    saveState()
    deleteToWatch(index: index)
    output?.notifyItemDeleted(at: index)
  }
  
  func selectItem(at index: Int) {
    items[index].isSelected.toggle()
    saveState()
    selectToWatch(item: items[index], at: index)
    output?.notifyItemSelected(at: index)
  }
  
  func moveItem(from originIndex: Int, to destinationIndex: Int) {
    guard originIndex != destinationIndex else { return }
    let item = items[originIndex]
    items.remove(at: originIndex)
    items.insert(item, at: destinationIndex)
    loadToWatch(items: items)
    saveState()
  }
  
  func syncToWatch() {
    loadItems()
    loadToWatch(items: items)
  }
}

extension ListInteractor: WatchSessionManagerAppOutput {
  func didActivateSession() {
    loadItems()
    loadToWatch(items: items)
  }
  
  func didReceiveReply(_ reply: [String : Any]) {
    
  }
  
  func didReceiveError(_ error: Error) {
    
  }
  
  func didReceiveMessage(_ message: WatchSessionMessageProtocol) {
    switch message.action {
    case WatchSessionMessageAction.load:
      loadItems()
    case WatchSessionMessageAction.select:
      selectItem(at: message.index)
    default:
      break
    }
  }
  
  private func itemFromMessage(_ message: WatchSessionMessageProtocol) -> ListItem? {
    guard let encodedItem = message.data else { return nil }
    guard let item = try? JSONDecoder().decode(ListItem.self, from: encodedItem) else { return nil }
    return item
  }
}

fileprivate extension String {
  func sanitized() -> String {
    return self.lowercased().folding(options: .diacriticInsensitive, locale: .current)
  }
}
