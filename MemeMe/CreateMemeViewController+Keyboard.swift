//
//  KeyboardNotificationManager.swift
//  MemeMe
//
//  Created by Hugo Murillo on 4/30/16.
//  Copyright © 2016 Maplonki. All rights reserved.
//

import UIKit

extension CreateMemeViewController {
    
    func subscribeToKeyboardNotifications(selector:Selector, name: String?) {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: selector,
            name: name,
            object: nil)
    }
    
    func subscribeFromKeyboardNotifications(name: String?) {
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: name,
            object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }

    
}