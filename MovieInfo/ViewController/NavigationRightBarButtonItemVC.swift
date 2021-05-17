//
//  FavoriteNavigationVC.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 16/05/2021.
//

import UIKit

class NavigationRightBarButtonItemVC: UIViewController {

  var movie: Movie!
  
  private var isFavorite = false


  init(movie: Movie) {
    super.init(nibName: nil, bundle: nil)
    self.movie = movie
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateUI()
  }

  private func updateUI() {
    let favorites = PersistenceManager.singleton.getFavoritesAsDictionary()
    isFavorite = favorites[movie.id] != nil
    DispatchQueue.main.async { self.updateNavigationRightBarButtonItem() }
  }

  private func updateNavigationRightBarButtonItem() {
    if isFavorite {
      navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .trash, target: self, action: #selector(removeFromFavorite))
      navigationItem.rightBarButtonItem?.tintColor = .systemRed
    } else {
      navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(addToFavorite))
    }
  }
  
  @objc func addToFavorite() {
    PersistenceManager.singleton.saveToFavorite(movie: movie) { [weak self] error in
      guard let self = self else { return }
      self.processFavoriteStatus(error: error, isAdded: true)
    }
  }

  @objc func removeFromFavorite() {
    PersistenceManager.singleton.removeFromFavorite(movieId: movie.id) { [weak self] error in
      guard let self = self else { return }
      self.processFavoriteStatus(error: error, isAdded: false)
    }
  }

  private func processFavoriteStatus(error: MIError?, isAdded: Bool) {
    if let error = error {
      presentAlertOnMainQueue(body: error.rawValue)
    } else {
      let title = isAdded ? "Added" : "Removed"
      let style = isAdded ? Style.add : Style.remove
      presentAlertOnMainQueue(title: title, body: "Favorites successfully updated.", style: style)
      isFavorite.toggle()
      DispatchQueue.main.async { self.updateNavigationRightBarButtonItem() }
    }
  }
}
