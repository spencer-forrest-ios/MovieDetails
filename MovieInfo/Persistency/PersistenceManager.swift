//
//  PersistenceManager.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 15/05/2021.
//

import Foundation


class PersistenceManager {
  
  static let singleton = PersistenceManager()
  private let userDefaults = UserDefaults.standard


  private init() {}

  func removeFromFavorite(movieId: Int, completion: @escaping (MIError?)->()) {
    var favorites = getFavoritesAsDictionary()
    favorites[movieId] = nil
    updateFavorite(favorites: favorites, completion: completion)
  }

  func saveToFavorite(movie: Movie, completion: @escaping (MIError?)->()) {
    var favorites = getFavoritesAsDictionary()
    favorites[movie.id] = Favorite(id: movie.id, title: movie.title, overview: movie.overview, posterPath: movie.posterPath)
    updateFavorite(favorites: favorites, completion: completion)
  }

  func getFavoritesSortedByTitleAsc() -> [Favorite] { return getFavoritesAsDictionary().values.sorted { $0.title < $1.title } }
  
  func getFavoritesAsDictionary() -> [Int: Favorite] {
    guard let data = userDefaults.object(forKey: Key.favorite) as? Data else { return [:] }

    let favorites = try? JSONDecoder().decode([Int: Favorite].self, from: data)
    
    return favorites == nil ? [:] : favorites!
  }

  private func updateFavorite(favorites: [Int: Favorite], completion: @escaping (MIError?)->()) {
    do {
      let data = try JSONEncoder().encode(favorites)
      userDefaults.setValue(data, forKey: Key.favorite)
      completion(nil)
    } catch {
      completion(.unableToUpdateFavoriteList)
    }
  }
}
