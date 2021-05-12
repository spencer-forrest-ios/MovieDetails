//
//  UIView+Ext.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 10/05/2021.
//

import UIKit

extension UIViewController {

  func presentAlertOnMainThread(title: String, body: String, buttonTittle: String) {
    DispatchQueue.main.async {
      let alert = UIAlertController.init(title: title, message: body, preferredStyle: .alert)
      alert.addAction(UIAlertAction.init(title: buttonTittle, style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
}
