//
//  Constant.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 08/05/2021.
//

import UIKit

enum Color {
  static let logo = UIColor.init(named: "logo")!
  static let background = UIColor.tertiarySystemBackground
  static let contentView = UIColor.systemFill
}

enum Image {
  static let logo = UIImage.init(named: "logo")!
  static let attribution = UIImage.init(named: "api-logo")!
  // 􀛥
  static let popular = UIImage.init(systemName: "bolt.heart.fill")!
  // 􀏅
  static let placeholder = UIImage.init(systemName: "photo")!
}

enum VideoType {
  static let trailer = "trailer"
}

enum Site {
  static let youtube = "youtube"
  static let vimeo = "vimeo"

  static let vimeoURLString = "https://vimeo.com/"
  static let youtubeURLString = "https://www.youtube.com/watch?v="

  static let vimeoAppUrlstring = "vimeo://videos/"
  static let youtubeAppURLString = "youtube://"
}
