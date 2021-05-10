//
//  UIStackView+Ext.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 09/05/2021.
//

import UIKit

extension UIStackView {
  func addArrangedSubviews(_ views: [UIView]) {
    for view in views {
      addArrangedSubview(view)
    }
  }

  func setCustomSpacingEqually(_ spacing: CGFloat) {
    for view in arrangedSubviews {
      setCustomSpacing(spacing, after: view)
    }
  }
}
