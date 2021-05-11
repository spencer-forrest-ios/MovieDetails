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
}
