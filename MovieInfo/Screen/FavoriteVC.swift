//
//  FavoriteVC.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 09/05/2021.
//

import UIKit

class FavoriteVC: LoadingVC {

  private var tableView: UITableView!

  private var allFavorites = [Favorite]()
  private var filteredFavorites = [Favorite]()

  private let searchTextFieldPlaceHolder = "Search for a title"
  

  override func viewDidLoad() {
    super.viewDidLoad()

    setupNavigationController()
    setupTableView()

    registerKeyboardNotifications()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    refreshAllFavorites()
    filteredFavorites = allFavorites

    updateUI()
  }

  private func refreshAllFavorites() { allFavorites = PersistenceManager.singleton.getFavoritesSortedByTitleAsc() }

  private func updateUI(isReloadDataNeeded: Bool = true, duration: TimeInterval = 0) {
    if filteredFavorites.isEmpty {
      setupEmptyStateOnMainQueue(message: EmptyState.favorite, animationDuration: duration)
      disableSearchController()
    } else {
      enableSearchController()
      removeEmptyStateOnMainQeue()
      if isReloadDataNeeded { tableView.reloadData() }
    }
  }

  private func disableSearchController() {
    guard let searchController = navigationItem.searchController else { return }

    let searchTextField = searchController.searchBar.searchTextField
    searchTextField.text = nil
    searchTextField.placeholder = "Search disabled"
    searchTextField.isEnabled = false
    searchTextField.resignFirstResponder()

    searchController.isActive = false
  }

  private func enableSearchController() {
    guard let searchController = navigationItem.searchController else { return }

    let searchTextField = searchController.searchBar.searchTextField
    searchTextField.placeholder = searchTextFieldPlaceHolder
    searchTextField.isEnabled = true
  }

  private func setupNavigationController() {
    title = "Favorites"
    navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: Image.top, style: .plain, target: self, action: #selector(scrollToTop))
    navigationItem.searchController = UIHelper.createSearchController(placeHolder: searchTextFieldPlaceHolder, delegate: self)
    navigationItem.hidesSearchBarWhenScrolling = false
  }

  @objc func scrollToTop() {
    guard filteredFavorites.count > 0 else { return }
    tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
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
        self.updateFavoriteArrays(indexPath: indexPath)
        self.updateTableViewOnMainQueue(indexPath: indexPath)
      }
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedMovie = filteredFavorites[indexPath.row].convertToMovie()
    navigationController?.pushViewController(MovieVC.init(movie: selectedMovie), animated: true)
  }

  private func updateFavoriteArrays(indexPath: IndexPath) {
    self.refreshAllFavorites()
    self.filteredFavorites.remove(at: indexPath.row)
  }

  private func updateTableViewOnMainQueue(indexPath: IndexPath) {
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


// MARK: Keyboard will show and will hide notifications
extension FavoriteVC {

  private func registerKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(expandScrollView), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(reduceScrollView), name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  @objc func expandScrollView(_ notification: Notification) {
    guard var keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue) as? CGRect else { return }

    keyboardFrame = view.convert(keyboardFrame, from: view.window)
    
    let heightOverlap = tableView.frame.maxY - keyboardFrame.origin.y - tabBarController!.tabBar.frame.height

    tableView.verticalScrollIndicatorInsets.bottom = heightOverlap
    tableView.contentInset.bottom = heightOverlap
  }

  @objc func reduceScrollView() {
    guard filteredFavorites.count > 0 else { return }

    tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
    tableView.verticalScrollIndicatorInsets.bottom = .zero
    tableView.contentInset.bottom = .zero
  }
}
