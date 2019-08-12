//
//  WatchSessionReply.swift
//  List
//
//  Created by Rémi Caroff on 07/04/2019.
//  Copyright © 2019 Rémi Caroff. All rights reserved.
//

import Foundation

protocol WatchSessionReplyProtocol: Codable {
  var success: Bool { get }
}

struct WatchSessionReply: WatchSessionReplyProtocol {
  var success: Bool
}
