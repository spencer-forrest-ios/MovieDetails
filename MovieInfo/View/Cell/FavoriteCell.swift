//
//  FavoriteCell.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 15/05/2021.
//

import UIKit

class FavoriteCell: UITableViewCell {

  static let reuseIdentifier = "FavoriteCellID"

  private var poster = MIImageView()
  private var titleLabel = UILabel()
  private let separator = UIView()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func set(title: String, posterPath: String?) {
    titleLabel.text = title
    poster.downloadImage(path: posterPath)
  }

  private func setup() {
    selectionStyle = .none

    separator.backgroundColor = .label

    titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
    titleLabel.numberOfLines = 2
    titleLabel.adjustsFontSizeToFitWidth = true
    titleLabel.minimumScaleFactor = 0.8
    titleLabel.textAlignment = .center

    contentView.addSubviews(poster, titleLabel, separator)

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    separator.translatesAutoresizingMaskIntoConstraints = false
    let padding: CGFloat = 10
    NSLayoutConstraint.activate([
      poster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
      poster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
      poster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
      poster.widthAnchor.constraint(equalTo: poster.heightAnchor, multiplier: 0.67),

      titleLabel.topAnchor.constraint(equalTo: poster.topAnchor),
      titleLabel.bottomAnchor.constraint(equalTo: poster.bottomAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: padding),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

      separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      separator.heightAnchor.constraint(equalToConstant: 1)
    ])
  }
}
