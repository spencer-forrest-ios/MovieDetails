//
//  Favorite.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 16/05/2021.
//

import Foundation

struct Favorite: Codable {
  var id: Int
  var title: String
  var overview: String
  var posterPath: String?

  func convertToMovie() -> MovieData { return MovieData.init(id: id, title: title, overview: overview, posterPath: posterPath) }
}
