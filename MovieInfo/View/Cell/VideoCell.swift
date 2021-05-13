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

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func set(title: String) {
    titleLabel.text = title
  }

  private func configure() {

    selectionStyle = .none

    titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
    titleLabel.numberOfLines = 2
    titleLabel.adjustsFontSizeToFitWidth = true
    titleLabel.minimumScaleFactor = 0.8

    contentView.addSubview(titleLabel)

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.pinToEdgesOf(contentView, padding: 20)
  }
  
}
