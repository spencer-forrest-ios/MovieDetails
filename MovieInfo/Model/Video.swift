//
//  Video.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 13/05/2021.
//

import Foundation

/// The video object has an array of details (property `result`)
/// that give us enough information to watch youtube/vimeo videos associated with the movie
/// (trailers, behind the scenes, etc...).
struct Video: Decodable {
  var movieId: Int
  var results: [Detail]

  private enum CodingKeys: String, CodingKey {
    case results, movieId = "id"
  }
}
