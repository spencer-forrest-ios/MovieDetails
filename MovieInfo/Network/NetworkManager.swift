//
//  NetworkManager.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 11/05/2021.
//

import UIKit


class NetworkManager {

  static let singleton = NetworkManager()
  private let cache = NSCache<NSString, UIImage>()

  
  private init() {}

  /// Search for a movie using its title through a request to the web API
  /// - Parameters:
  ///   - title: title to search for
  ///   - page: page result requested
  ///   - completion: closure executed when http request has been completed
  ///   - result: search result or error description
  func searchForMovie(title: String, page: Int, completion: @escaping (_ result: Result<Response, MIError>)->()) {
    getDataFromWebApi(url: MovieApi.createSearchURL(title: title, page: page), completion: completion)
  }

  /// Get popular movies of the current year through a request to the web API
  /// - Parameters:
  ///   - page: page result requested
  ///   - completion: closure executed when http request has been completed
  ///   - result: search result or error description
  func getPopularMovies(page: Int, completion: @escaping (_ result: Result<Response, MIError>)->()) {
    getDataFromWebApi(url: MovieApi.createPopularURL(page: page), completion: completion)
  }

  /// Get a poster (image) from the web API or retrieve it from cache
  /// - Parameters:
  ///   - posterPath: unique path of the poster
  ///   - completion: closure executed when request has been completed
  ///   - image: poster downloaded or retrieved from cache if no error occured
  func downloadPoster(posterPath: String, completion: @escaping (_ image: UIImage?)->()) {

    let cacheKey = NSString.init(string: posterPath)

    if let image = cache.object(forKey: cacheKey) {
      completion(image)
      return
    }

    URLSession.shared.dataTask(with: MovieApi.createImageUrl(posterPath: posterPath)) { [weak self] data, response, error in

      guard let self = self, let data = data, let image = UIImage.init(data: data) else {
        completion(nil)
        return
      }

      self.cache.setObject(image, forKey: cacheKey)
      completion(image)

    }.resume()
  }

  /// Get a video object associated with a specific movie
  ///
  /// - Parameters:
  ///   - movieId: id of the movie
  ///   - completion: closure executed when request has been completed
  ///   - result: video or error description
  func getVideos(movieId: Int, completion: @escaping (_ result: Result<Video, MIError>)->()) {
    getDataFromWebApi(url: MovieApi.createVideoUrl(movieId: movieId), completion: completion)
  }
  
  /// Get data from web api
  ///
  /// - Parameters:
  ///   - url: A value that identifies the location of a resource in remote server
  ///   - completion: closure executed when request has been completed
  ///   - result: decodable struct or error description
  private func getDataFromWebApi<T>(url: URL, completion: @escaping (_ result: Result<T, MIError>)->()) where T: Decodable {
    URLSession.shared.dataTask(with: url) { data, urlResponse, error in

      guard let data = data else {
        completion(.failure(.unableToComplete))
        return
      }

      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase

      do {
        let response = try decoder.decode(T.self, from: data)
        completion(.success(response))
      } catch {
        completion(.failure(.invalidData))
      }
    }.resume()
  }
}
