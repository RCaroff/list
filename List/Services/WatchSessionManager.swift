//
//  WatchSessionManager.swift
//  List
//
//  Created by Rémi Caroff on 07/04/2019.
//  Copyright © 2019 Rémi Caroff. All rights reserved.
//

import Foundation
import WatchConnectivity

// MARK: - Protocols

protocol WatchSessionManagerInput {
  func setWatchOutput(_ output: WatchSessionManagerWatchOutput)
  func setAppOutput(_ output: WatchSessionManagerAppOutput)
  func startSession()
  func send(message: WatchSessionMessage) throws
}

protocol WatchSessionManagerWatchOutput: class {
  func didActivateSession()
  func didReceiveReply(_ reply: [String: Any])
  func didReceiveError(_ error: Error)
  func didReceiveMessage(_ message: WatchSessionMessageProtocol)
}

protocol WatchSessionManagerAppOutput: class {
  func didActivateSession()
  func didReceiveMessage(_ message: WatchSessionMessageProtocol)
  func didReceiveError(_ error: Error)
}

// MARK: - Implementation

class WatchSessionManager: NSObject {
  static let shared: WatchSessionManager = WatchSessionManager()
  weak var watchOutput: WatchSessionManagerWatchOutput?
  weak var appOutput: WatchSessionManagerAppOutput?
  private let session: WCSession = WCSession.default
  
  override init() {
    super.init()
    session.delegate = self
  }
}

// MARK: - WatchSessionManagerInput

extension WatchSessionManager: WatchSessionManagerInput {
  
  func setAppOutput(_ output: WatchSessionManagerAppOutput) {
    appOutput = output
  }
  
  func setWatchOutput(_ output: WatchSessionManagerWatchOutput) {
    watchOutput = output
  }
  
  func startSession() {
    session.activate()
  }
  
  func send(message: WatchSessionMessage) throws {
    session.sendMessageData(try JSONEncoder().encode(message), replyHandler: { replyData in
      print("Reply data : \(replyData)")
    }) { [unowned self] error in
      self.watchOutput?.didReceiveError(error)
    }
  }
}

// MARK: - WCSessionDelegate

extension WatchSessionManager: WCSessionDelegate {
  
  #if os(iOS) 
  func sessionDidBecomeInactive(_ session: WCSession) {}
  func sessionDidDeactivate(_ session: WCSession) {}
  #endif

  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    if let error = error { watchOutput?.didReceiveError(error) }
    if activationState == .activated {
      #if os(iOS)
      appOutput?.didActivateSession()
      #else
      watchOutput?.didActivateSession()
      #endif
    }
  }
  
  func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
    guard let message = try? JSONDecoder().decode(WatchSessionMessage.self, from: messageData) else { return }
    #if os(iOS)
    appOutput?.didReceiveMessage(message)
    #else
    watchOutput?.didReceiveMessage(message)
    #endif
  }
  
  func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
    guard let message = try? JSONDecoder().decode(WatchSessionMessage.self, from: messageData) else { return }
    #if os(iOS)
    appOutput?.didReceiveMessage(message)
    #else
    watchOutput?.didReceiveMessage(message)
    #endif
  }
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    print("message :\(message)")
  }
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
    print("message :\(message)")
  }
}
