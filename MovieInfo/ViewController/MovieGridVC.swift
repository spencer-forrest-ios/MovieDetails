//
//  MovieGridVC.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 10/05/2021.
//

import UIKit

typealias MovieGridVC = MovieGridClass & MovieGridProtocol

protocol MovieGridProtocol: AnyObject { func getMovies(page: Int) }

class MovieGridClass: LoadingVC {

  private enum Section { case main }

  private var collectionView: UICollectionView!
  private var dataSource: UICollectionViewDiffableDataSource<Section, Movie>!
  private var snapshot: NSDiffableDataSourceSnapshot<Section, Movie>!

  var movies = [Movie]()

  private var currentPage = 1
  private var totalPages = 1
  private var isNotLoadingResult = true

  private weak var controller: MovieGridProtocol!

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setupController()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  convenience init(title: String) {
    self.init(nibName: nil, bundle: nil)
    self.title = title
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

    if movies.isEmpty { getMovies(page: 1) }
  }

  final func updateCollectionView(with response: Response) {
    updateData(with: response)
    updateUI()
  }

  private func setupController() {
    guard let controller = self as? MovieGridVC else { return }
    self.controller = controller
  }

  private func getMovies(page: Int) { controller.getMovies(page: page) }

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
    collectionView.delegate = self
    collectionView.backgroundColor = Color.background
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
extension MovieGridClass: UICollectionViewDelegate {

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let currentOffsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let scrollViewHeight = scrollView.frame.height

    let tabBarHeight = tabBarController!.tabBar.frame.height

    // Change 100 to adjust the distance from the bottom
    if currentOffsetY + scrollViewHeight - contentHeight - tabBarHeight >= 100 {
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
