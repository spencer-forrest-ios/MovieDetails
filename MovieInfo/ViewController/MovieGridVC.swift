//
//  MovieGridVC.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 10/05/2021.
//

import UIKit

class MovieGridVC: UIViewController {

  private enum Section { case main, secondary }

  private var dataSource: UICollectionViewDiffableDataSource<Section, Movie>!
  private var collectionView: UICollectionView!
  
  
  private var movies: [Movie] = [
    Movie.init(title: "Mortal Kombat", image: Image.placeholder),
    Movie.init(title: "Avatar", image: Image.placeholder2),
    Movie.init(title: "Birds of Prey (and the Fantabulous Emancipation of One Harley Quinn)", image: Image.placeholder),
    
    Movie.init(title: "The Flash", image: Image.placeholder),
    Movie.init(title: "Fear the Walking Dead", image: Image.placeholder2),
    Movie.init(title: "Game of Thrones", image: Image.placeholder),
    
    Movie.init(title: "New Gods: Nezha Reborn", image: Image.placeholder),
    Movie.init(title: "Mortal Kombat 2", image: Image.placeholder2),
    Movie.init(title: "Mortal Kombat 3", image: Image.placeholder),
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.setNavigationBarHidden(false, animated: true)

    instantiateCollectionView()
    instantiateDataSource()

    view.addSubview(collectionView)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    reloadData(with: movies)
  }

  private func instantiateCollectionView() {
    collectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
    collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
    collectionView.backgroundColor = .systemBackground
  }

  private func instantiateDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Section, Movie>.init(collectionView: collectionView) { collectionView, indexPath, movie in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as! MovieCell
      cell.setCell(posterImage: movie.image, title: movie.title)
      return cell
    }
  }

  private func reloadData(with movies: [Movie]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
    snapshot.appendSections([.main])
    snapshot.appendItems(movies, toSection: .main)

    dataSource.apply(snapshot, animatingDifferences: true)
  }
}
