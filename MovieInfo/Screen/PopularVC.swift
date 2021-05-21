//
//  PopularVC.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 19/05/2021.
//

import UIKit

class PopularVC: MovieGridVC {

  private var isNotLoadingResult = true
  private var countryCode: String?


  init(title: String, countryCode: String?) {
    super.init(title: title)
    self.countryCode = countryCode
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  func getMovies(page: Int) {
    guard isNotLoadingResult else { return }

    isNotLoadingResult = false
    startActivityIndicator()

    NetworkManager.singleton.getPopularMovies(page: page, country: countryCode) { [weak self] result in
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
