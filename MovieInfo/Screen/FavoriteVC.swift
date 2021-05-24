//
//  FavoriteVC.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 09/05/2021.
//

import UIKit

class FavoriteVC: LoadingVC {

  private var tableView: UITableView!
  private var filteredFavorites = [Favorite]()
  private var allFavorites = [Favorite]()
  

  override func viewDidLoad() {
    super.viewDidLoad()

    setupNavigationController()
    setupTableView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    allFavorites = PersistenceManager.singleton.getFavoritesSortedByTitleAsc()
    filteredFavorites = allFavorites

    updateUI()
  }

  @objc func scrollToTop() {
    guard filteredFavorites.count > 0 else { return }
    tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
  }

  private func updateUI(isReloadDataNeeded: Bool = true, duration: TimeInterval = 0) {
    if filteredFavorites.isEmpty {
      setupEmptyStateOnMainQueue(message: EmptyState.favorite, animationDuration: duration)
      navigationItem.searchController = nil
    } else {
      setupSearchBar()
      removeEmptyStateOnMainQeue()
      if isReloadDataNeeded { tableView.reloadData() }
    }
  }

  private func setupNavigationController() {
    title = "Favorites"
    navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: Image.top, style: .plain, target: self, action: #selector(scrollToTop))
    navigationItem.hidesSearchBarWhenScrolling = false
  }

  private func setupTableView() {
    tableView = UITableView.init(frame: view.bounds)
    tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseIdentifier)

    tableView.dataSource = self
    tableView.delegate = self

    tableView.rowHeight = 100
    tableView.backgroundColor = Color.background
    tableView.separatorStyle = .none
    tableView.tableFooterView = UIView()

    view.addSubview(tableView)
  }

  private func setupSearchBar() {
    let searchController = UISearchController()
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search for a title"

    navigationItem.searchController = searchController
  }
}


// MARK: UITableViewDataSource
extension FavoriteVC: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return filteredFavorites.count }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let favorite = filteredFavorites[indexPath.row]

    let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseIdentifier) as! FavoriteCell
    cell.set(title: favorite.title, posterPath: favorite.posterPath)
    
    return cell
  }
}


// MARK: UITableViewDelegate
extension FavoriteVC: UITableViewDelegate {

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }

    PersistenceManager.singleton.removeFromFavorite(movieId: filteredFavorites[indexPath.row].id) { [weak self] error in
      guard let self = self else { return }

      if let error = error {
        self.presentAlertOnMainQueue(body: error.rawValue)
      } else {
        self.removeFavorite(indexPath: indexPath)
      }
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedMovie = filteredFavorites[indexPath.row].convertToMovie()
    navigationController?.pushViewController(MovieVC.init(movie: selectedMovie), animated: true)
  }

  private func removeFavorite(indexPath: IndexPath) {
    self.filteredFavorites.remove(at: indexPath.row)

    DispatchQueue.main.async {
      self.tableView.deleteRows(at: [indexPath], with: .left)
      self.updateUI(isReloadDataNeeded: false, duration: 0.75)
    }
  }
}


// MARK: UISearchResultsUpdating
extension FavoriteVC: UISearchResultsUpdating {

  func updateSearchResults(for searchController: UISearchController) {
    guard let search = searchController.searchBar.text else { return }

    let searchedTitle = search.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    filteredFavorites = searchedTitle.isEmpty ? allFavorites : allFavorites.filter { $0.title.lowercased().contains(searchedTitle) }
    
    tableView.reloadData()
  }
}
