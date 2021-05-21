//
//  TabBarController.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 08/05/2021.
//

import UIKit

class TabBarController: UITabBarController {

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }


  override func viewDidLoad() {
    super.viewDidLoad()

    UINavigationBar.appearance().tintColor = Color.logo
    configureTabBarAppearance()

    viewControllers = [createSearchScreen(), createPopularScreen(), createFavoriteScreen()]
  }

  /// Create navigation controller with SearchVC as root view controller and its tab bar item
  /// - Returns: navigation controller
  private func createSearchScreen() -> UINavigationController {
    let navigationVC = UINavigationController.init(rootViewController: SearchVC())
    navigationVC.tabBarItem = UITabBarItem.init(tabBarSystemItem: .search, tag: 0)
    
    return navigationVC
  }

  /// Create navigation controller with PopularVC as root view controller and its tab bar item
  /// - Returns: navigation controller
  private func createPopularScreen() -> UINavigationController {
    let navigationVC = UINavigationController.init(rootViewController: CountryListVC.init(style: .plain))
    navigationVC.tabBarItem = UITabBarItem.init(title: "Popular", image: Image.popular, tag: 1)

    return navigationVC
  }

  /// Create navigation controller with FavoriteVC as root view controller and its tab bar item
  /// - Returns: navigation controller
  private func createFavoriteScreen() -> UINavigationController {
    let navigationVC = UINavigationController.init(rootViewController: FavoriteVC())
    navigationVC.tabBarItem = UITabBarItem.init(tabBarSystemItem: .favorites, tag: 2)

    return navigationVC
  }

  /// Configure overall appearance of tab bar
  private func configureTabBarAppearance() {
    UITabBar.appearance().tintColor = Color.logo
    UITabBar.appearance().unselectedItemTintColor = .systemGray
  }
}
