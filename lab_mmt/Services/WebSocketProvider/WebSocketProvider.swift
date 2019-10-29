//
//  File.swift
//  WebRTC-Demo
//
//  Created by Stas Seldin on 15/07/2019.
//  Copyright © 2019 Stas Seldin. All rights reserved.
//

import Foundation

protocol WebSocketProvider: class {
    var delegate: WebSocketProviderDelegate? { get set }
    func connect()
    func send(data: Data)
}

protocol WebSocketProviderDelegate: class {
    func webSocketDidConnect(_ webSocket: WebSocketProvider)
    func webSocketDidDisconnect(_ webSocket: WebSocketProvider)
    func webSocket(_ webSocket: WebSocketProvider, didReceiveData data: Data)
    func webSocket(_ webSocket: WebSocketProvider, didReceiveString string: String)
}
