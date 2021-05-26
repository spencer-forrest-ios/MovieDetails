//
//  UIHelper.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 10/05/2021.
//

import UIKit

enum UIHelper {
  
  static func createTwoColumnFlowLayout(in view: UIView) -> UICollectionViewLayout {
    let width = view.bounds.width
    let padding: CGFloat = 10
    let availabelWidth = width - (padding * 3)
    let itemWidth = availabelWidth / 2
    
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.sectionInset = UIEdgeInsets.init(top: padding, left: padding, bottom: padding, right: padding)
    flowLayout.itemSize = CGSize.init(width: itemWidth, height: itemWidth * 1.5 + 60)

    return flowLayout
  }

  static func createSearchController(placeHolder: String, delegate: UISearchResultsUpdating) -> UISearchController {
    let searchController = UISearchController()
    searchController.searchResultsUpdater = delegate

    searchController.searchBar.placeholder = placeHolder
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = false

    searchController.searchBar.searchTextField.removeShortcutBarForiPadKeyboard()

    return searchController
  }
}
