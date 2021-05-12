//
//  Constant.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 08/05/2021.
//

import UIKit

enum Api {

  static func createSearchURL(search: String, page: Int = 1) -> URL {
    var urlComponents = createBaseUrlComponents()
    urlComponents.path = Api.searchPath

    urlComponents.queryItems = [
      Api.apiKeyQueryItem,
      Api.languageQueryItem,
      Api.adultQueryItem,
      Api.createPageQueryItem(page: String(page)),
      Api.createSearchQueryItem(search: search)
    ]

    return urlComponents.url!
  }

  static func createImageUrl(posterPath: String) -> URL {
    var urlComponents = URLComponents.init()
    urlComponents.scheme = Api.scheme
    urlComponents.host = Api.posterHost
    urlComponents.path = Api.posterPath + posterPath

    return urlComponents.url!
  }

  private static func createBaseUrlComponents() -> URLComponents {
    var urlComponents = URLComponents.init()
    urlComponents.scheme = Api.scheme
    urlComponents.host = Api.host

    return urlComponents
  }

  private static let scheme = "https"
  private static let host = "api.themoviedb.org"
  private static let posterHost = "image.tmdb.org"

  private static let version = "/3"

  private static let posterPath = "/t/p/w200"
  private static let popularPath = version + "/discover/movie"
  private static let searchPath = version + "/search/movie"

  private static func createMoviePath(movieId: String) -> String { version + "/movie/\(movieId)" }
  private static func createTrailerPath(movieId: String) -> String { version + "/movie/\(movieId)/videos" }

  //  private static let key = "PUT_YOUR_API_KEY_HERE"

  private static let adultQueryItem = URLQueryItem.init(name: "include_adult", value: "false")
  private static let apiKeyQueryItem = URLQueryItem.init(name: "api_key", value: Api.key)
  private static let languageQueryItem = URLQueryItem.init(name: "language", value: "en")
  private static let sinceDateQueryItem = URLQueryItem.init(name: "release_date.gte", value: Date.getFirstDateOfCurrentYearAsString())
  private static let sortingQueryItem = URLQueryItem.init(name: "sort_by", value: "popularity.desc")

  private static func createPageQueryItem(page: String) -> URLQueryItem { URLQueryItem.init(name: "page", value: page) }
  private static func createSearchQueryItem(search: String) -> URLQueryItem { URLQueryItem.init(name: "query", value: search) }
}

enum Color {
  static let logo = UIColor.init(named: "logo")!
  static let background = UIColor.tertiarySystemBackground
}

enum Image {
  static let logo = UIImage.init(named: "logo")!
  static let attribution = UIImage.init(named: "api-logo")!
  // 􀛥
  static let popular = UIImage.init(systemName: "bolt.heart.fill")!
  // 􀏅
  static let placeholder = UIImage.init(systemName: "photo")!
}
