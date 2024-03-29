//
//  MovieApi.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 11/05/2021.
//

import Foundation

enum MovieApi {

  static func createSearchURL(title: String, page: Int) -> URL {
    var urlComponents = createBaseUrlComponents()
    urlComponents.path = MovieApi.searchPath

    urlComponents.queryItems = [
      MovieApi.apiKeyQueryItem,
      MovieApi.languageQueryItem,
      MovieApi.excludeAdultQueryItem,
      MovieApi.createSearchQueryItem(search: title),
      MovieApi.createPageQueryItem(page: String(page))
    ]

    return urlComponents.url!
  }

  static func createUpcomingURL(regionCode: String?, page: Int) -> URL {
    var urlComponents = createBaseUrlComponents()
    urlComponents.path = MovieApi.upcomingPath

    urlComponents.queryItems = [
      MovieApi.apiKeyQueryItem,
      MovieApi.createPageQueryItem(page: String(page))
    ]

    if let code = regionCode { urlComponents.queryItems?.append(MovieApi.createRegionQueryItem(code: code)) }
    
    return urlComponents.url!
  }

  static func createImageUrl(posterPath: String) -> URL {
    var urlComponents = URLComponents()
    urlComponents.scheme = MovieApi.scheme
    urlComponents.host = MovieApi.posterHost
    urlComponents.path = MovieApi.posterPath + posterPath

    return urlComponents.url!
  }

  static func createVideoUrl(movieId: Int) -> URL {
    var urlComponents = createBaseUrlComponents()
    urlComponents.path = MovieApi.createTrailerPath(movieId: "\(movieId)")

    urlComponents.queryItems = [
      MovieApi.apiKeyQueryItem,
      MovieApi.languageQueryItem,
    ]

    return urlComponents.url!
  }

  private static func createBaseUrlComponents() -> URLComponents {
    var urlComponents = URLComponents()
    urlComponents.scheme = MovieApi.scheme
    urlComponents.host = MovieApi.host

    return urlComponents
  }

  private static let scheme = "https"
  private static let host = "api.themoviedb.org"
  private static let posterHost = "image.tmdb.org"

  private static let version = "/3"

  private static let posterPath = "/t/p/w400"
  private static let upcomingPath = version + "/movie/upcoming"
  private static let searchPath = version + "/search/movie"

  private static func createTrailerPath(movieId: String) -> String { version + "/movie/\(movieId)/videos" }

  //  private static let key = "PUT_YOUR_API_KEY_HERE"

  private static let excludeAdultQueryItem = URLQueryItem.init(name: "include_adult", value: "false")
  private static let apiKeyQueryItem = URLQueryItem.init(name: "api_key", value: MovieApi.key)
  private static let languageQueryItem = URLQueryItem.init(name: "language", value: "en-US")

  private static func createPageQueryItem(page: String) -> URLQueryItem { URLQueryItem.init(name: "page", value: page) }
  private static func createRegionQueryItem(code: String) -> URLQueryItem { URLQueryItem.init(name: "region", value: code) }
  private static func createSearchQueryItem(search: String) -> URLQueryItem { URLQueryItem.init(name: "query", value: search) }
}
