//
//  Response.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 12/05/2021.
//

import Foundation

struct Response: Decodable {
  var page: Int
  var movies: [MovieData]
  var totalPages: Int
  var totalResults: Int

  private enum CodingKeys: String, CodingKey { case page, movies = "results", totalPages, totalResults }
}
