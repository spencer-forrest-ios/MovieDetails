//
//  MIEmptyStateView.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 16/05/2021.
//

import UIKit

class MIEmptyStateView: UIView {
  let messageLabel = UILabel()

  init(message: String) {
    super.init(frame: .zero)

    backgroundColor = Color.background

    messageLabel.text = message
    messageLabel.font = UIFont.preferredFont(forTextStyle: .title1)
    messageLabel.textAlignment = .center
    messageLabel.numberOfLines = 0
    messageLabel.alpha = 0

    self.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(messageLabel)
    messageLabel.pinToEdgesOf(self)
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
