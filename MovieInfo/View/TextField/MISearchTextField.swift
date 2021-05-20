//
//  MITextField.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 09/05/2021.
//

import UIKit

class MISearchTextField: UITextField {

  init() {
    super.init(frame: .zero)
    configure()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  private func configure() {
    translatesAutoresizingMaskIntoConstraints = false

    layer.cornerRadius = 10
    layer.borderWidth = 2
    layer.borderColor = UIColor.systemGray2.cgColor

    placeholder = "Please enter the title here"
    textAlignment = .center

    clearButtonMode = .whileEditing
    returnKeyType = .search
    tintColor = .label
  }
}
