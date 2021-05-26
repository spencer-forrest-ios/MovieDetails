//
//  UITextField+Ext.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 26/05/2021.
//

import UIKit

extension UITextField {

  func removeShortcutBarForiPadKeyboard() {
    // empty keyboard's shortcuts bar for ipads
    inputAssistantItem.leadingBarButtonGroups = []
    inputAssistantItem.trailingBarButtonGroups = []
  }
}


