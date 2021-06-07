//
//  MovieCell.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 10/05/2021.
//

import UIKit

class MovieCell: UICollectionViewCell {
  
  static let reuseIdentifier = "MovieCellID"
  
  private let posterIV = MIImageView()
  private let titleLabel = UILabel()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    setupTitleLabel()
    setupContentView()

    layoutUI()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  func setCell(posterPath: String?, title: String) {
    titleLabel.text = title
    posterIV.downloadImage(path: posterPath)
  }

  private func setupTitleLabel() {
    titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    titleLabel.numberOfLines = 2
    titleLabel.textAlignment = .center
  }

  private func setupContentView() {
    contentView.backgroundColor = Color.contentView
    contentView.layer.cornerRadius = 10
  }

  private func layoutUI() {
    contentView.addSubviews(posterIV, titleLabel)
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let padding: CGFloat = 10
    
    NSLayoutConstraint.activate([
      posterIV.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
      posterIV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
      posterIV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
      posterIV.heightAnchor.constraint(equalTo: posterIV.widthAnchor, multiplier: 1.5),
      
      titleLabel.topAnchor.constraint(equalTo: posterIV.bottomAnchor, constant: padding),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
      titleLabel.heightAnchor.constraint(equalToConstant: 60)
    ])
  }
}
