//
//  UIViewController+Ext.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 09/05/2021.
//

import UIKit

extension UIView {

  func addSubviews(_ views: UIView...) {
    for view in views { addSubview(view) }
  }

  func pinToSafeAreaEdgesOf(_ view: UIView, padding: CGFloat = 0) {
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
      bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
      leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
      trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding)
    ])
  }

  func pinToEdgesOf(_ view: UIView, padding: CGFloat = 0) {
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
      bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
      leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
    ])
  }
}
