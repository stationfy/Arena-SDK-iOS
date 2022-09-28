//
//  MessageResponse.swift
//  ArenaChatSDK
//
//  Created by Erick Vicente on 30/08/22.
//

import Foundation

struct MessageResponse {
    let message: Message
    let action: MessageResponseAction
}

enum MessageResponseAction {
    case added(index: UInt)
    case modified(from: UInt, to: UInt)
    case removed(index: UInt)
}
