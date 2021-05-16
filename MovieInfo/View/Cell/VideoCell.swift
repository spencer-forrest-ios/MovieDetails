//
//  VideoCell.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 13/05/2021.
//

import UIKit

class VideoCell: UITableViewCell {

  static let reuseIdentifier = "VideoCellID"

  private let titleLabel = UILabel()
  private let separator = UIView()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
    layoutUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func set(title: String) {
    titleLabel.text = title
  }

  private func setupViews() {
    backgroundColor = .systemFill
    selectionStyle = .none

    separator.backgroundColor = .label

    titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
    titleLabel.numberOfLines = 2
    titleLabel.adjustsFontSizeToFitWidth = true
    titleLabel.minimumScaleFactor = 0.8
  }

  private func layoutUI() {
    contentView.addSubviews(titleLabel, separator)

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.pinToEdgesOf(contentView, padding: 20)

    separator.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      separator.heightAnchor.constraint(equalToConstant: 1)
    ])
  }
  
}
