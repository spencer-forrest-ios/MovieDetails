//
//  MovieGridVC.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 10/05/2021.
//

import UIKit

typealias MovieGridVC = MovieGridProtocol & MovieGridController


protocol MovieGridProtocol: AnyObject { func getMovies(page: Int) }


class MovieGridController: LoadingVC {

  var movies = [MovieData]()
  var navigationBarTitle = ""

  private enum Section { case main }

  private var collectionView: UICollectionView!
  private var dataSource: UICollectionViewDiffableDataSource<Section, MovieData>!
  private var snapshot: NSDiffableDataSourceSnapshot<Section, MovieData>!

  private var currentPage = 1
  private var totalPages = 1
  private var isNotLoadingResult = true

  private weak var controller: MovieGridProtocol!


  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  init(title: String) {
    super.init(nibName: nil, bundle: nil)

    navigationBarTitle = title
    setupController()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    instantiateCollectionView()
    instantiateDataSource()
    
    view.addSubview(collectionView)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if movies.isEmpty { getMovies(page: 1) }
    setupNavigationController()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    title = nil
  }

  final func updateCollectionView(with response: Response) {
    updateData(with: response)
    updateUIOnMainQueue()
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

  private func updateUIOnMainQueue() {
    if movies.isEmpty {
      setupEmptyStateOnMainQueue(message: EmptyState.movie)
      DispatchQueue.main.async { self.navigationItem.rightBarButtonItem = nil }
    } else {
      removeEmptyStateOnMainQeue()
      DispatchQueue.main.async {
        let rightButton = UIBarButtonItem.init(image: Image.top, style: .plain, target: self, action: #selector(self.scrollToTop))
        self.navigationItem.rightBarButtonItem = rightButton
      }
      reloadData(with: movies)
    }
  }

  @objc func scrollToTop() {
    guard movies.count > 0 else { return }
    collectionView.scrollToItem(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
  }

  private func reloadData(with movies: [MovieData]) {
    snapshot = NSDiffableDataSourceSnapshot<Section, MovieData>()
    snapshot.appendSections([.main])
    snapshot.appendItems(movies, toSection: .main)

    DispatchQueue.main.async { self.dataSource.apply(self.snapshot, animatingDifferences: true) }
  }

  private func instantiateDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Section, MovieData>.init(collectionView: collectionView) { collectionView, indexPath, movie in

      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as! MovieCell
      cell.setCell(posterPath: movie.posterPath, title: movie.title)

      return cell
    }
  }

  private func setupNavigationController() {
    title = navigationBarTitle

    navigationController?.setNavigationBarHidden(false, animated: true)
    navigationController?.navigationBar.prefersLargeTitles = true
  }

  private func instantiateCollectionView() {
    collectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: view))
    collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
    collectionView.delegate = self
    collectionView.backgroundColor = Color.background
  }
}


// MARK: UICollectionViewDelegate
extension MovieGridController: UICollectionViewDelegate {

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let currentOffsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let scrollViewHeight = scrollView.frame.height

    let tabBarHeight = tabBarController!.tabBar.frame.height

    // Change 150 to adjust the distance from the bottom
    if currentOffsetY + scrollViewHeight - contentHeight - tabBarHeight >= 150 {
      if currentPage < totalPages { getMovies(page: currentPage + 1) }
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let movie = movies[indexPath.row]
    navigationController?.pushViewController(MovieVC.init(movie: movie), animated: true)
  }
}
