//
//  Search.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 12/05/2021.
//

import Foundation

struct Search: Decodable {
  var page: Int
  var results: [Movie]
  var totalPages: Int
  var totalResults: Int
}
