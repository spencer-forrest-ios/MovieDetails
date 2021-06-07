//
//  MIButton.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 09/05/2021.
//

import UIKit

class MIButton: UIButton {

  var isDisable: Bool {
    get { return !isEnabled }
    set {
      isEnabled = !newValue
      alpha = newValue ? 0.5 : 1
    }
  }

  private var isContrasted = false

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  init(title: String?, isContrasted: Bool = false) {
    super.init(frame: .zero)
    setTitle(title, for: .normal)
    self.isContrasted = isContrasted
    configure()
  }

  private func configure() {
    translatesAutoresizingMaskIntoConstraints = false
    layer.cornerRadius = 10

    titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    titleLabel?.adjustsFontSizeToFitWidth = true

    if isContrasted {
      backgroundColor = .secondarySystemFill

      layer.borderColor = Color.logo.cgColor
      layer.borderWidth = 2

      setTitleColor(Color.logo, for: .normal)
    } else {
      setTitleColor(.systemBackground, for: .normal)
      backgroundColor = Color.logo
    }

    addTarget(self, action: #selector(animateAlpha), for: .touchUpInside)
  }

  @objc func animateAlpha() {
    alpha = 0.8
    UIView.animate(withDuration: 0, delay: 0.15) { [weak self] in
      guard let self = self else { return }
      self.alpha = 1
    }
  }
}
