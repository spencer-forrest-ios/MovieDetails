//
//  UIImageView+Ext.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 12/05/2021.
//

import UIKit

extension UIImageView {

  func downloadImage(path: String?) {
    guard let path = path else {
      image = Image.placeholder
      return
    }

    NetworkManager.singleton.downloadPoster(posterPath: path) { [weak self] image in
      guard let self = self, let image = image else {
        self?.image = Image.placeholder
        return
      }

      DispatchQueue.main.async { self.image = image }
    }
  }
}
