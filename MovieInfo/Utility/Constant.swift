//
//  Constant.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 08/05/2021.
//

import UIKit

enum Color {
  static let logo = UIColor.init(named: ColorName.logo)!
}

enum Image {
  static let logo = UIImage.init(named: ImageName.logo)!
  static let attribution = UIImage.init(named: ImageName.attributiion)!
  // 􀛥
  static let popular = UIImage.init(systemName: ImageName.popular)!
}

private enum ColorName {
  static let logo = "logo"
}

private enum ImageName {
  static let logo = "logo"
  static let attributiion = "api-logo"
  static let popular = "bolt.heart.fill"
}
