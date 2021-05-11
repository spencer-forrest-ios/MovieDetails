//
//  MovieCell.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 10/05/2021.
//

import UIKit

class MovieCell: UICollectionViewCell {
  
  static let reuseIdentifier = "MovieCellID"
  
  private let posterIV = UIImageView()
  private let titleLabel = UILabel()
  
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    contentView.addSubviews(posterIV, titleLabel)
    configure()
    layoutUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setCell(posterImage: UIImage, title: String) {
    posterIV.image = posterImage
    titleLabel.text = title
  }
  
  private func configure() {
    titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    titleLabel.numberOfLines = 2
    titleLabel.textAlignment = .center
    
    posterIV.contentMode = .scaleAspectFit
  }
  
  private func layoutUI() {
    posterIV.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let padding: CGFloat = 5
    
    NSLayoutConstraint.activate([
      posterIV.topAnchor.constraint(equalTo: contentView.topAnchor),
      posterIV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      posterIV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      posterIV.heightAnchor.constraint(equalTo: posterIV.widthAnchor, multiplier: 1.5),
      
      titleLabel.topAnchor.constraint(equalTo: posterIV.bottomAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
      titleLabel.heightAnchor.constraint(equalToConstant: 60)
    ])
  }
}
