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

  func searchMovie(search: String, page: Int = 1, completion: @escaping (Result<Search, MIError>)->()) {
    
    URLSession.shared.dataTask(with: Api.createSearchURL(search: search, page: page)) { data, urlResponse, error in

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

  func downloadPoster(posterPath: String, completion: @escaping (UIImage?)->()) {

    let cacheKey = NSString.init(string: posterPath)

    if let image = cache.object(forKey: cacheKey) {
      completion(image)
      return
    }

    URLSession.shared.dataTask(with: Api.createImageUrl(posterPath: posterPath)) { [weak self] data, urlResponse, error in

      guard let self = self,
            let response = urlResponse as? HTTPURLResponse,
            response.statusCode == 200,
            let data = data,
            let image = UIImage.init(data: data),
            error == nil
      else {
        completion(nil)
        return
      }

      self.cache.setObject(image, forKey: cacheKey)
      completion(image)

    }.resume()
  }
}
