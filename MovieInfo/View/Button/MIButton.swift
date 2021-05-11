//
//  MIButton.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 09/05/2021.
//

import UIKit

class MIButton: UIButton {
  init() {
    super.init(frame: .zero)
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  convenience init(title: String, backgroundColor: UIColor = Color.logo) {
    self.init()
    self.backgroundColor = backgroundColor
    setTitle(title, for: .normal)
  }

  private func configure() {
    translatesAutoresizingMaskIntoConstraints = false
    layer.cornerRadius = 10

    titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    setTitleColor(.systemBackground, for: .normal)
  }
}
