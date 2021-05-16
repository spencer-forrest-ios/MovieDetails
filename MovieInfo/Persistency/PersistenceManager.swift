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

  func removeFromFavorite(movieId: Int) {
    var favorites = getFavoritesAsDictionary()
    favorites[movieId] = nil
    updateFavorite(favorites: favorites)
  }

  func saveToFavorite(movie: Movie) {
    var favorites = getFavoritesAsDictionary()
    favorites[movie.id] = Favorite(id: movie.id, title: movie.title, posterPath: movie.posterPath)
    updateFavorite(favorites: favorites)
  }

  func getFavorites() -> [Favorite] {
    return getFavoritesAsDictionary().values.sorted{ $0.title < $1.title }
  }

  #warning("Use Try Catch + completion handler for error message")
  func getFavoritesAsDictionary() -> [Int: Favorite] {

    guard let data = userDefaults.object(forKey: Key.favorite) as? Data else { return [:] }

    let favorites = try? JSONDecoder().decode([Int: Favorite].self, from: data)

    return favorites == nil ? [:] : favorites!
  }

  #warning("Use Try Catch + completion handler for error message")
  private func updateFavorite(favorites: [Int: Favorite]) {
    userDefaults.setValue(try? JSONEncoder().encode(favorites), forKey: Key.favorite)
  }
}