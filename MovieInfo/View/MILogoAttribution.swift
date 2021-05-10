//
//  MILogoAttribution.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 10/05/2021.
//

import UIKit

class MILogoAttribution: UIView {

  private let imageView = UIImageView.init(image: Image.attribution)
  private let attributionLabel = UILabel()
  private let horizontalSV = UIStackView()


  init() {
    super.init(frame: .zero)

    imageView.contentMode = .scaleAspectFit

    configureHorizontalSV()
    configureAttributionLabel()

    layoutUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configureAttributionLabel() {
    attributionLabel.text = "This product uses the TMDb API but is not endorsed or certified by TMDb."
    attributionLabel.font = UIFont.preferredFont(forTextStyle: .body)
    attributionLabel.adjustsFontSizeToFitWidth = true

    attributionLabel.textAlignment = .justified
    attributionLabel.lineBreakMode = .byTruncatingTail
    attributionLabel.numberOfLines = 4
  }

  private func configureHorizontalSV() {
    horizontalSV.axis = .horizontal
    horizontalSV.alignment = .center
  }

  private func layoutUI(){
    addSubviews()
    layoutHorizontalSV()
    layoutImageView()
  }

  private func addSubviews() {
    addSubview(horizontalSV)
    horizontalSV.addArrangedSubviews([imageView, attributionLabel])
  }

  private func layoutHorizontalSV() {
    horizontalSV.translatesAutoresizingMaskIntoConstraints = false

    horizontalSV.setCustomSpacingEqually(50)
    horizontalSV.pinToEdgesOf(self)
  }

  private func layoutImageView() {
    imageView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/4),
      imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
    ])
  }
}
