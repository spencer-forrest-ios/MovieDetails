//
//  FavoriteVC.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 09/05/2021.
//

import UIKit

class FavoriteVC: LoadingVC {

  private var tableView: UITableView!

  private var favorites = [Favorite]()
  private var selectedMovie: Movie!

  override func viewDidLoad() {
    super.viewDidLoad()

    setupTableView()
    setupController()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getFavorites()
  }

  private func getFavorites() {
    favorites = PersistenceManager.singleton.getFavorites()
    tableView.reloadData()
  }

  private func setupController() {
    title = "Favorite"
  }

  private func setupTableView() {
    tableView = UITableView.init(frame: view.bounds)
    tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseIdentifier)

    tableView.rowHeight = 80
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.backgroundColor = Color.background

    tableView.dataSource = self
    tableView.delegate = self

    view.addSubview(tableView)
  }
}


extension FavoriteVC: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favorites.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let favorite = favorites[indexPath.row]

    let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseIdentifier) as! FavoriteCell
    cell.set(title: favorite.title, posterPath: favorite.posterPath)

    return cell
  }
}

extension FavoriteVC: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let movieId = favorites[indexPath.row].id
    getMovie(id: movieId)
  }

  private func pushMovieViewController() {
    self.navigationController?.pushViewController(MovieVC.init(movie: self.selectedMovie), animated: true)
  }

  private func getMovie(id: Int) {

    startActivityIndicator()

    NetworkManager.singleton.getMovie(movieId: id) { [weak self] result in

      guard let self = self else { return }

      switch result {
      case .failure(let error):
        self.presentAlertOnMainQueue(body: error.rawValue)
      case .success(let movie):
        self.selectedMovie = movie
        DispatchQueue.main.async { self.pushMovieViewController() }
      }
      
      self.stopActivityIndicatorOnMainQueue()
    }
  }
}
