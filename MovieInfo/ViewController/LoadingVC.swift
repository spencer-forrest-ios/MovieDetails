//
//  LoadingVC.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 12/05/2021.
//

import UIKit

class LoadingVC: UIViewController {
  
  private var loadingView = UIView()
  private var indicatorView = UIActivityIndicatorView.init(style: .large)


  func startActivityIndicator() {
    loadingView.frame = view.bounds
    loadingView.backgroundColor = .systemBackground
    loadingView.alpha = 0.6
    layoutViews()
    indicatorView.startAnimating()
  }

  func stopActivityIndicatorOnMainQueue() {
    DispatchQueue.main.async {
      self.indicatorView.stopAnimating()
      self.removeViewsFromMainView()
    }
  }

  private func layoutViews() {
    indicatorView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(loadingView)
    loadingView.addSubview(indicatorView)

    NSLayoutConstraint.activate([
      indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }

  private func removeViewsFromMainView() {
    indicatorView.removeFromSuperview()
    loadingView.removeFromSuperview()
  }
}
