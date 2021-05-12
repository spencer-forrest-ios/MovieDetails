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
    setupViews()
    layoutUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setCell(posterPath: String?, title: String) {
    posterIV.downloadImage(path: posterPath)

    posterIV.image = Image.placeholder2
    titleLabel.text = title
  }

  private func setupViews() {
    titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    titleLabel.numberOfLines = 2
    titleLabel.textAlignment = .center
    
    posterIV.contentMode = .scaleAspectFit
    posterIV.layer.cornerRadius = 5
    posterIV.clipsToBounds = true

    contentView.backgroundColor = .systemFill
    contentView.layer.cornerRadius = 10
  }
  
  private func layoutUI() {
    posterIV.translatesAutoresizingMaskIntoConstraints = false
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
