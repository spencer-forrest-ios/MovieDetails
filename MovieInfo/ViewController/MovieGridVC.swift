//
//  MovieGridVC.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 10/05/2021.
//

import UIKit

class MovieGridVC: LoadingVC {

  private enum Section { case main }

  private var dataSource: UICollectionViewDiffableDataSource<Section, Movie>!
  private var snapshot: NSDiffableDataSourceSnapshot<Section, Movie>!
  private var collectionView: UICollectionView!

  private var movies = [Movie]()

  private var currentPage = 1
  private var totalPages = 1
  private var isNotLoadingResult = true

  
  override func viewDidLoad() {
    super.viewDidLoad()

    instantiateCollectionView()
    instantiateDataSource()

    view.addSubview(collectionView)

    searchMovie(page: 1)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    setupNavigationController()
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

  private func reloadData(with movies: [Movie]) {
    snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
    snapshot.appendSections([.main])
    snapshot.appendItems(movies, toSection: .main)

    DispatchQueue.main.async { self.dataSource.apply(self.snapshot, animatingDifferences: true) }
  }
  
  private func searchMovie(page: Int) {

    guard isNotLoadingResult else { return }

    isNotLoadingResult = false
    startActivityIndicator()

    NetworkManager.singleton.searchMovie(search: title!, page: page) { [weak self] result in

      guard let self = self else { return }

      switch result {
      case .failure(let error):
        self.presentAlertOnMainQueue(title: "Error", body: error.rawValue, buttonTittle: "Ok")
        break
      case.success(let search):
        self.updateData(with: search)
        break
      }
      
      self.isNotLoadingResult = true
      self.stopActivityIndicatorOnMainQueue()
    }
  }

  private func updateData(with search: Search) {
    movies.append(contentsOf: search.results)
    currentPage = search.page
    totalPages = search.totalPages
    reloadData(with: movies)
  }
}


// MARK: UICollectionViewDelegate
extension MovieGridVC: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    if indexPath.row == snapshot.numberOfItems - 1 && currentPage != totalPages {
      searchMovie(page: currentPage + 1)
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    let movie = movies[indexPath.row]
    navigationController?.pushViewController(MovieVC.init(movie: movie), animated: true)
    
  }
}
