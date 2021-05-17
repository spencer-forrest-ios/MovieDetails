//
//  MovieGridVC.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 10/05/2021.
//

import UIKit

enum MovieResultType {
  case search, popular
}

class MovieGridVC: LoadingVC {

  private enum Section { case main }

  private var dataSource: UICollectionViewDiffableDataSource<Section, Movie>!
  private var snapshot: NSDiffableDataSourceSnapshot<Section, Movie>!
  private var collectionView: UICollectionView!

  private var movies = [Movie]()
  private var movieResultType: MovieResultType!

  private var currentPage = 1
  private var totalPages = 1
  private var isNotLoadingResult = true


  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  convenience init(title: String, movieResultType: MovieResultType = .search) {
    self.init(nibName: nil, bundle: nil)
    self.title = title
    self.movieResultType = movieResultType
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    instantiateCollectionView()
    instantiateDataSource()

    view.addSubview(collectionView)

    getMovies(page: 1)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigationController()

    if movies.isEmpty { getMovies(page: 1)}
  }

  private func getMovies(page: Int) {

    guard isNotLoadingResult else { return }

    isNotLoadingResult = false
    startActivityIndicator()

    switch movieResultType {
    case .search:
      searchForMovie(page: page)
    case .popular:
      getPopularMovies(page: page)
    case .none:
      break
    }
  }

  private func getPopularMovies(page: Int) {
    NetworkManager.singleton.getPopularMovies(page: page) { [weak self] result in

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

  private func searchForMovie(page: Int) {
    NetworkManager.singleton.searchForMovie(title: title!, page: page) { [weak self] result in

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

  private func handlePopularError(error: MIError) {
    if movies.isEmpty { setupEmptyStateOnMainQueue(message: error.rawValue) }
    if !movies.isEmpty { presentAlertOnMainQueue(body: error.rawValue) }
  }

  private func updateCollectionView(with response: Response) {
    updateData(with: response)
    updateUI()
  }

  private func updateData(with response: Response) {
    movies.append(contentsOf: response.movies)
    currentPage = response.page
    totalPages = response.totalPages
  }

  private func updateUI() {
    if movies.isEmpty {
      setupEmptyStateOnMainQueue(message: EmptyState.movie)
    } else {
      removeEmptyStateOnMainQeue()
      reloadData(with: movies)
    }
  }

  private func reloadData(with movies: [Movie]) {
    snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
    snapshot.appendSections([.main])
    snapshot.appendItems(movies, toSection: .main)

    DispatchQueue.main.async { self.dataSource.apply(self.snapshot, animatingDifferences: true) }
  }

  private func setupNavigationController() {
    navigationController?.setNavigationBarHidden(false, animated: true)
    navigationController?.navigationBar.prefersLargeTitles = true
  }

  private func instantiateCollectionView() {
    collectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: view))
    collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
    collectionView.backgroundColor = Color.background
    collectionView.delegate = self
  }

  private func instantiateDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Section, Movie>.init(collectionView: collectionView) { collectionView, indexPath, movie in

      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as! MovieCell
      cell.setCell(posterPath: movie.posterPath, title: movie.title)

      return cell
    }
  }
}


// MARK: UICollectionViewDelegate
extension MovieGridVC: UICollectionViewDelegate {

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let height = scrollView.frame.height
    let tabBarHeight = tabBarController!.tabBar.frame.height

    // Change 100 to adjust the distance from the bottom
    if offsetY + height - tabBarHeight - contentHeight  >= 100 {
      if currentPage != totalPages {
        getMovies(page: currentPage + 1)
      }
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let movie = movies[indexPath.row]
    navigationController?.pushViewController(MovieVC.init(movie: movie), animated: true)
  }
}
