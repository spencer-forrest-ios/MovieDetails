//
//  MIImageView.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 13/05/2021.
//

import UIKit

class MIImageView: UIImageView {
  
  override init(frame: CGRect = .zero) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  func setup() {
    translatesAutoresizingMaskIntoConstraints = false

    tintColor = Color.logo
    
    contentMode = .scaleAspectFit
    layer.cornerRadius = 10
    clipsToBounds = true
  }
}
