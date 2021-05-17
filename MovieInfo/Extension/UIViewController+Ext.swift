//
//  UIView+Ext.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 10/05/2021.
//

import UIKit

enum Style {
  case normal, add, remove
}

extension UIViewController {

  func presentAlertOnMainQueue(title: String = "Something went wrong", body: String, style: Style = .normal) {
    DispatchQueue.main.async {
      let alert = UIAlertController.init(title: title, message: body, preferredStyle: .alert)
      alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
      alert.view.tintColor = Color.logo

      if style != .normal {
        let color = style == .add ? UIColor.systemBlue : UIColor.systemRed
        let attributes = [
          NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .headline),
          NSAttributedString.Key.foregroundColor : color
        ]
        let attributedString = NSAttributedString(string: alert.title!, attributes: attributes)
        alert.setValue(attributedString, forKey: "attributedTitle")
      }

      self.present(alert, animated: true, completion: nil)
    }
  }
}
