//
//  UIViewController+Ext.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 09/05/2021.
//

import UIKit

extension UIView {

  func pinToSafeAreaEdgesOf(_ view: UIView) {

    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
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
