//
//  MovieVC.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 12/05/2021.
//

import UIKit

class MovieVC: LoadingVC {

  private var movie: Movie!

  private var verticalSV = UIStackView()
  private var contentView = UIView()
  private var posterImageView = UIImageView()
  private var overViewTextView = UITextView()
  private var overViewLabel = UILabel()
  private var trailerButton: MIButton!

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  convenience init(movie: Movie) {
    self.init(nibName: nil, bundle: nil)
    self.movie = movie
    trailerButton = MIButton.init(title: movie.title)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = movie.title

    view.backgroundColor = Color.background
    setupVerticalStackView()

    contentView.layer.cornerRadius = 10
    contentView.backgroundColor = Color.contentView

    posterImageView.contentMode = .scaleAspectFit
    posterImageView.layer.cornerRadius = 5
    posterImageView.clipsToBounds = true
    posterImageView.downloadImage(path: movie.posterPath)

    overViewLabel.text = "Synopsis (scrollable)"
    overViewLabel.font = UIFont.preferredFont(forTextStyle: .headline)

    overViewTextView.font = UIFont.preferredFont(forTextStyle: .body)
    overViewTextView.text = movie.overview
    overViewTextView.backgroundColor = .systemFill
    overViewTextView.layer.cornerRadius = 10
    overViewTextView.delegate = self

    trailerButton.backgroundColor = Color.logo
    trailerButton.setTitleColor(.white, for: .normal)
    trailerButton.setTitle("Trailers", for: .normal)
    trailerButton.isEnabled = false
    trailerButton.alpha = 0.5

    addSubviews()
    layoutUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = false
  }

  private func setupVerticalStackView() {
    verticalSV.axis = .vertical
    verticalSV.alignment = .center
    verticalSV.distribution = .fill
  }

  private func addSubviews() {
    verticalSV.translatesAutoresizingMaskIntoConstraints = false
    contentView.translatesAutoresizingMaskIntoConstraints = false
    posterImageView.translatesAutoresizingMaskIntoConstraints = false
    overViewTextView.translatesAutoresizingMaskIntoConstraints = false

    verticalSV.addArrangedSubviews(contentView, overViewLabel, overViewTextView, trailerButton)

    view.addSubview(verticalSV)
    contentView.addSubview(posterImageView)

  }

  private func layoutUI() {
    let padding: CGFloat = view.bounds.width * 0.05

    verticalSV.pinToSafeAreaEdgesOf(view, padding: padding)
    verticalSV.setCustomSpacingEqually(padding/2)

    NSLayoutConstraint.activate([

      contentView.widthAnchor.constraint(equalTo: verticalSV.widthAnchor, multiplier: 1/2),
      contentView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.5),

      posterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      posterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      posterImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -30),
      posterImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -30),

      overViewTextView.leadingAnchor.constraint(equalTo: verticalSV.leadingAnchor, constant: 0),
      overViewTextView.trailingAnchor.constraint(equalTo: verticalSV.trailingAnchor, constant: -0),

      trailerButton.heightAnchor.constraint(equalToConstant: 50),
      trailerButton.leadingAnchor.constraint(equalTo: verticalSV.leadingAnchor, constant: 0),
      trailerButton.trailingAnchor.constraint(equalTo: verticalSV.trailingAnchor, constant: -0),
    ])
  }
}


// MARK: UITextFieldDelegate
extension MovieVC: UITextViewDelegate {

  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    return false
  }
}
