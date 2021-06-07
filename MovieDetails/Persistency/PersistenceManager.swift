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

  func getRegionCode() -> String? { return userDefaults.string(forKey: Key.region) }

  func saveRegionCode(_ code: String) { userDefaults.setValue(code, forKey: Key.region) }

  func removeFromFavorite(movieId: Int, completion: @escaping (MIError?)->()) {
    var favorites = getFavoritesAsDictionary()
    favorites[movieId] = nil
    updateFavorite(favorites: favorites, completion: completion)
  }

  func saveToFavorite(movie: MovieData, completion: @escaping (MIError?)->()) {
    var favorites = getFavoritesAsDictionary()
    favorites[movie.id] = movie.convertToFavorite()
    updateFavorite(favorites: favorites, completion: completion)
  }

  func getFavoritesSortedByTitleAsc() -> [Favorite] { return getFavoritesAsDictionary().values.sorted { $0.title < $1.title } }
  
  func getFavoritesAsDictionary() -> [Int: Favorite] {
    guard let data = userDefaults.data(forKey: Key.favorite) else { return [:] }

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
