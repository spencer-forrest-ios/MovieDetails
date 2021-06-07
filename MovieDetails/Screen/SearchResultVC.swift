//
//  SearchResultVC.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 19/05/2021.
//

import UIKit

class SearchResultVC: MovieGridVC {

  private var isNotLoadingResult = true

  
  func getMovies(page: Int) {
    guard isNotLoadingResult else { return }

    isNotLoadingResult = false
    startActivityIndicator()

    NetworkManager.singleton.getMovie(by: navigationBarTitle, page: page) { [weak self] result in
      guard let self = self else { return }

      switch result {
      case .failure(let error):
        self.handleSearchError(error: error)
      case.success(let response):
        self.updateCollectionView(with: response)
      }

      self.isNotLoadingResult = true
      self.stopActivityIndicatorOnMainQueue()
    }
  }

  private func handleSearchError(error: MIError) {
    DispatchQueue.main.async { self.navigationController?.popViewController(animated: true) }
    presentAlertOnMainQueue(body: error.rawValue)
  }
}
