//
//  User.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 10/05/2021.
//

import UIKit

struct Movie: Decodable, Hashable {
  var identifier = UUID()

  var id: Int
  var title: String
  var overview: String
  var posterPath: String?

  private enum CodingKeys: CodingKey { case id, title, overview, posterPath }

  init(id: Int, title: String, overview: String, posterPath: String?) {
    self.id = id
    self.title = title
    self.overview = overview
    self.posterPath = posterPath
  }

  func hash(into hasher: inout Hasher) { hasher.combine(identifier) }

  static func == (lhs: Movie, rhs: Movie) -> Bool { return lhs.identifier == rhs.identifier }
}
