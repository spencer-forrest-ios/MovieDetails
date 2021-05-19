//
//  PopularVC.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 19/05/2021.
//

import UIKit

class PopularVC: MovieGridVC {

  private var isNotLoadingResult = true

  func getMovies(page: Int) {
    guard isNotLoadingResult else { return }

    isNotLoadingResult = false
    startActivityIndicator()

    NetworkManager.singleton.getPopularMovies(page: page) { [weak self] result in
      guard let self = self else { return }

      switch result {
      case .failure(let error):
        self.handlePopularError(error: error)
      case.success(let response):
        self.updateCollectionView(with: response)
      }

      self.isNotLoadingResult = true
      self.stopActivityIndicatorOnMainQueue()
    }
  }

  private func handlePopularError(error: MIError) {
    if movies.isEmpty { setupEmptyStateOnMainQueue(message: error.rawValue) }
    if !movies.isEmpty { presentAlertOnMainQueue(body: error.rawValue) }
  }
}
