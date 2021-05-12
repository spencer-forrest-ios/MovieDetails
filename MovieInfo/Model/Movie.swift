//
//  User.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 10/05/2021.
//

import UIKit

struct Movie: Decodable, Hashable {
  var id: Int
  var title: String
  var overview: String
  var posterPath: String?
}
