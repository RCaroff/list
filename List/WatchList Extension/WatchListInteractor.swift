//
//  WatchListInteractor.swift
//  WatchList Extension
//
//  Created by Rémi Caroff on 22/04/2019.
//  Copyright © 2019 Rémi Caroff. All rights reserved.
//

import Foundation

// MARK: - Protocols

protocol WatchListInteractorInput {
  func setOutput(_ output: WatchListInteractorOutput)
  func activateSession()
  func item(atIndex index: Int) -> ListItemProtocol?
  func numberOfItems() -> Int
  func didSelectItem(at index: Int)
}

protocol WatchListInteractorOutput: class {
  func notifyItemsUpdated()
  func notifyItemDeleted(at index: Int)
  func notifyItemAdded(item: ListItemProtocol, at index: Int)
  func notifyItemSelected(item: ListItemProtocol, at index: Int)
}

// MARK: - Implementation

final class WatchListInteractor {
  
  var watchSessionManager: WatchSessionManagerInput!
  private var repository: ListRepositoryProtocol
  private var items: [ListItem] = []
  weak var output: WatchListInteractorOutput?
  
  init(repository: ListRepositoryProtocol) {
    self.repository = repository
  }
  
  private func tryAddItemData(data: Data?, at index: Int) {
    do {
      guard let data = data else { return }
      let item = try JSONDecoder().decode(ListItem.self, from: data)
      items.append(item)
      output?.notifyItemAdded(item: item, at: index)
    } catch {
      print("Error trying to add item")
    }
  }
  
  private func tryUpdateItems(data: Data?) {
    do {
      guard let data = data else { return }
      let items = try JSONDecoder().decode([ListItem].self, from: data)
      self.items = items
      output?.notifyItemsUpdated()
    } catch {
      print("Error trying to update item")
    }
  }
  
  private func tryToggleSelection(data: Data?, at index: Int) {
    do {
      guard let data = data else { return }
      let item = try JSONDecoder().decode(ListItem.self, from: data)
      items[index] = item
      output?.notifyItemSelected(item: item, at: index)
    } catch {
      print("Error trying to toggle selection")
    }
  }
  
  private func save() {
    do {
      let dataModels = items.map { ListItemDataModel(label: $0.label, isSelected: $0.isSelected) }
      try repository.save(dataModels: dataModels)
    } catch {
      print("Cannot save items")
    }
  }
}

// MARK: - WatchListInteractorInput

extension WatchListInteractor: WatchListInteractorInput {
  
  func didSelectItem(at index: Int) {
    items[index].isSelected.toggle()
    do {
      let data = try JSONEncoder().encode(items[index])
      let message = WatchSessionMessage(action: WatchSessionMessageAction.select, index: index, data: data)
      try watchSessionManager.send(message: message)
    } catch {
      print("Watch cannot send message")
    }
    
    output?.notifyItemSelected(item: items[index], at: index)
  }
  
  func setOutput(_ output: WatchListInteractorOutput) {
    self.output = output
  }
  
  func activateSession() {
    watchSessionManager.startSession()
  }
  
  func numberOfItems() -> Int {
    return items.count
  }
  
  func item(atIndex index: Int) -> ListItemProtocol? {
    guard index < items.count else { return nil }
    return items[index]
  }
}

// MARK: - WatchSessionManagerWatchOutput

extension WatchListInteractor: WatchSessionManagerWatchOutput {
  func didActivateSession() {
    do {
      let message = WatchSessionMessage(action: WatchSessionMessageAction.load, index: 0, data: nil)
      try watchSessionManager.send(message: message)
    } catch {
      print("Watch cannot send message")
    }
  }
  
  func didReceiveReply(_ reply: [String : Any]) {}
  
  func didReceiveError(_ error: Error) {
    print(error.localizedDescription)
  }
  
  func didReceiveMessage(_ message: WatchSessionMessageProtocol) {
    switch message.action {
    case WatchSessionMessageAction.delete:
      output?.notifyItemDeleted(at: message.index)
    case WatchSessionMessageAction.load:
      tryUpdateItems(data: message.data)
    case WatchSessionMessageAction.add:
      tryAddItemData(data: message.data, at: message.index)
    case WatchSessionMessageAction.select:
      tryToggleSelection(data: message.data, at: message.index)
    default:
      break
    }
    
    save()
  }
}
