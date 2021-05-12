//
//  MovieApi.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 11/05/2021.
//

import Foundation

enum MovieApi {

  static func createSearchURL(search: String, page: Int = 1) -> URL {
    var urlComponents = createBaseUrlComponents()
    urlComponents.path = MovieApi.searchPath

    urlComponents.queryItems = [
      MovieApi.apiKeyQueryItem,
      MovieApi.languageQueryItem,
      MovieApi.adultQueryItem,
      MovieApi.createPageQueryItem(page: String(page)),
      MovieApi.createSearchQueryItem(search: search)
    ]

    return urlComponents.url!
  }

  static func createImageUrl(posterPath: String) -> URL {
    var urlComponents = URLComponents.init()
    urlComponents.scheme = MovieApi.scheme
    urlComponents.host = MovieApi.posterHost
    urlComponents.path = MovieApi.posterPath + posterPath

    return urlComponents.url!
  }

  private static func createBaseUrlComponents() -> URLComponents {
    var urlComponents = URLComponents.init()
    urlComponents.scheme = MovieApi.scheme
    urlComponents.host = MovieApi.host

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
  private static let apiKeyQueryItem = URLQueryItem.init(name: "api_key", value: MovieApi.key)
  private static let languageQueryItem = URLQueryItem.init(name: "language", value: "en")
  private static let sinceDateQueryItem = URLQueryItem.init(name: "release_date.gte", value: Date.getFirstDateOfCurrentYearAsString())
  private static let sortingQueryItem = URLQueryItem.init(name: "sort_by", value: "popularity.desc")

  private static func createPageQueryItem(page: String) -> URLQueryItem { URLQueryItem.init(name: "page", value: page) }
  private static func createSearchQueryItem(search: String) -> URLQueryItem { URLQueryItem.init(name: "query", value: search) }
}
