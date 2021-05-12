//
//  MovieGridVC.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 10/05/2021.
//

import UIKit

class MovieGridVC: UIViewController {

  private enum Section { case main }

  private var dataSource: UICollectionViewDiffableDataSource<Section, Movie>!
  private var snapshot: NSDiffableDataSourceSnapshot<Section, Movie>!
  private var collectionView: UICollectionView!

  private var currentPage = 1
  private var totalPages = 1
  private var isWaitingResult = false

  
  override func viewDidLoad() {
    super.viewDidLoad()

    instantiateCollectionView()
    instantiateDataSource()
    instantiateSnapshot()

    view.addSubview(collectionView)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    setupNavigationController()
    searchMovie(page: 1)
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

  private func instantiateSnapshot() {
    snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
    snapshot.appendSections([.main])
  }

  private func reloadData(with movies: [Movie]) {
    snapshot.appendItems(movies, toSection: .main)

    DispatchQueue.main.async { self.dataSource.apply(self.snapshot, animatingDifferences: true) }
  }
  
  private func searchMovie(page: Int) {

    guard !isWaitingResult else { return }

    isWaitingResult = true

    NetworkManager.singleton.searchMovie(search: title!, page: page) { [weak self] result in

      guard let self = self else { return }

      switch result {
      case .failure(let error):
        self.presentAlertOnMainThread(title: "Error", body: error.rawValue, buttonTittle: "Ok")
        break
      case.success(let search):
        self.updateData(with: search)
        break
      }
      
      self.isWaitingResult = false
    }
  }

  private func updateData(with search: Search) {

    self.currentPage = search.page
    self.totalPages = search.totalPages
    self.reloadData(with: search.results)
  }
}


// MARK: UICollectionViewDelegate
extension MovieGridVC: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    if indexPath.row == snapshot.numberOfItems - 1 && currentPage != totalPages {
      searchMovie(page: currentPage + 1)
    }
  }
}
