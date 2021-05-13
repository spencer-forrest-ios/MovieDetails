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
  func searchMovie(title: String, page: Int = 1, completion: @escaping (_ result: Result<Search, MIError>)->()) {
    
    URLSession.shared.dataTask(with: MovieApi.createSearchURL(title: title, page: page)) { data, urlResponse, error in

      guard let data = data else {
        completion(.failure(.unableToComplete))
        return
      }

      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase

      do {
        let search = try decoder.decode(Search.self, from: data)
        completion(.success(search))
      } catch {
        completion(.failure(.invalidData))
      }
    }.resume()
  }

  /// Download an poster (image) from the web API or retrieve it from cache
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

    URLSession.shared.dataTask(with: MovieApi.createImageUrl(posterPath: posterPath)) { [weak self] data, urlResponse, error in

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

    URLSession.shared.dataTask(with: MovieApi.createVideoUrl(movieId: movieId)) { data, response, error in

      guard let data = data else {
        completion(.failure(.unableToComplete))
        return
      }

      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase

      do {
        let result = try decoder.decode(Video.self, from: data)
        completion(.success(result))
      } catch {
        completion(.failure(.invalidData))
      }
    }.resume()
  }
}
