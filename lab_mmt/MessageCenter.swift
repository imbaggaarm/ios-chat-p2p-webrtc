//
//  MessageCenter.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/29/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

//class MessageCenter {
//    static let `default` = MessageCenter()
//
//    private init() {}
//
//    func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?) {
//
//    }
//}

protocol NotificationName {
    var name: Notification.Name { get }
}

extension RawRepresentable where RawValue == String, Self: NotificationName {
    var name: Notification.Name {
        get {
            return Notification.Name(self.rawValue)
        }
    }
}

class MessageHandler {
    static let onNewMessage: Notification.Name = Notification.Name.init("on-new-message")
    static let messageUserInfoKey: String = "message-user-info-key"
    
    static let onPeerConnectionChanging: Notification.Name = Notification.Name.init("on-peer-connectin-changing")
}
