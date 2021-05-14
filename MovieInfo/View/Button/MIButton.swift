//
//  MIButton.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 09/05/2021.
//

import UIKit

class MIButton: UIButton {

  var isDisable: Bool {
    get {
      return !isEnabled
    }
    set {
      isEnabled = !newValue
      alpha = newValue ? 0.5 : 1
    }
  }

  init() {
    super.init(frame: .zero)
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  convenience init(title: String) {
    self.init()
    setTitle(title, for: .normal)
  }

  private func configure() {
    translatesAutoresizingMaskIntoConstraints = false
    layer.cornerRadius = 10

    titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)

    setTitleColor(.systemBackground, for: .normal)
    backgroundColor = Color.logo

    addTarget(self, action: #selector(buttonTouchedUpInside), for: .touchUpInside)
  }

  @objc func buttonTouchedUpInside() {
    alpha = 0.8
    UIView.animate(withDuration: 0, delay: 0.15) { [weak self] in
      guard let self = self else { return }
      self.alpha = 1
    }
  }
}
