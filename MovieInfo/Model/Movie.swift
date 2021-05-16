//
//  User.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 10/05/2021.
//

import UIKit

struct Movie: Codable, Hashable {
  var uuid = UUID()

  var id: Int
  var title: String
  var overview: String
  var posterPath: String?

  private enum CodingKeys: CodingKey {
    case id, title, overview, posterPath
  }
}
