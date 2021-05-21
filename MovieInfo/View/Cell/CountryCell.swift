//
//  CountryCell.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 20/05/2021.
//

import UIKit

class CountryCell: UITableViewCell {

  static let reuseIdentifier = "CountryCellID"

  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  func setCell(country name: String) { textLabel?.text = name }

  private func setupCell() {
    textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
    textLabel?.adjustsFontSizeToFitWidth = true
    textLabel?.minimumScaleFactor = 0.8

    selectionStyle = .default
  }
}
