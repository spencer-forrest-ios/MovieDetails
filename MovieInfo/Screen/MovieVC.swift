//
//  MovieVC.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 12/05/2021.
//

import UIKit

class MovieVC: NavigationRightBarButtonItemVC {

  private var video: Video!

  private var isOverviewEmpty: Bool!

  private var verticalSV = UIStackView()
  private var overviewLabel = UILabel()
  private var overviewTV = UITextView()

  private var posterIV = MIImageView()
  private var videoButton = MIButton.init(title: "Videos")


  override init(movie: Movie) { super.init(movie: movie) }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override func viewDidLoad() {
    super.viewDidLoad()

    isOverviewEmpty = movie.overview.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

    setupViewController()

    setupVerticalSV()
    setupOverviewLabel()
    setupOverviewTV()
    setupVideoButton()

    addSubviews()
    layoutUI()

    posterIV.downloadImage(path: movie.posterPath)
    getVideos()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = false
  }

  /// Get videos associated with this movie
  private func getVideos() {
    NetworkManager.singleton.getVideos(movieId: movie.id) { [weak self] result in
      guard let self = self else { return }

      switch result {
      case .failure(let error):
        self.presentAlertOnMainQueue(body: error.rawValue)
      case .success(let video):
        self.video = video
        DispatchQueue.main.async { self.videoButton.isDisable = video.results.isEmpty }
      }
    }
  }

  private func setupViewController() {
    title = movie.title
    view.backgroundColor = Color.background
  }
  
  private func setupVerticalSV() {
    verticalSV.axis = .vertical
    verticalSV.alignment = .center
    verticalSV.distribution = .fill
  }

  private func setupOverviewLabel() {
    overviewLabel.text = isOverviewEmpty ? "" : "Synopsis (scrollable)"
    overviewLabel.font = UIFont.preferredFont(forTextStyle: .headline)
  }

  private func setupOverviewTV() {
    if isOverviewEmpty {
      overviewTV.font = UIFont.preferredFont(forTextStyle: .title2)
      overviewTV.text = "NO SYNOPSIS AVAILABLE"
      overviewTV.textAlignment = .center
    } else {
      overviewTV.font = UIFont.preferredFont(forTextStyle: .body)
      overviewTV.text = movie.overview
      overviewTV.textAlignment = .justified
    }

    let padding: CGFloat = 10
    overviewTV.textContainerInset = UIEdgeInsets.init(top: padding, left: padding, bottom: padding, right: padding)
    overviewTV.backgroundColor = .systemFill
    overviewTV.layer.cornerRadius = 10
    overviewTV.delegate = self
  }

  private func setupVideoButton() {
    videoButton.isDisable = true
    videoButton.addTarget(self, action: #selector(videoButtonTapped), for: .touchUpInside)
  }

  @objc func videoButtonTapped() {
    var sortedResults = filterVideosByTrailerAndSortByNameAsc()
    sortedResults.append(contentsOf: filterVideosByNoTrailerAndSortByTypeAscThenNameAsc())

    video.results = sortedResults

    navigationController?.pushViewController(VideoVC.init(video: video, movie: movie), animated: true)
  }

  private func filterVideosByTrailerAndSortByNameAsc() -> [Detail] {
    let trailers = video.results.filter { $0.type.lowercased() == VideoType.trailer.lowercased() }
    return trailers.sorted { $0.name < $1.name }
  }

  private func filterVideosByNoTrailerAndSortByTypeAscThenNameAsc() -> [Detail] {
    let noTrailers = video.results.filter { $0.type.lowercased() != VideoType.trailer.lowercased() }
    return noTrailers.sorted { $0.type == $1.type ? $0.name < $1.name : $0.type < $1.type }
  }

  private func addSubviews() {
    view.addSubview(verticalSV)
    verticalSV.addArrangedSubviews(posterIV, overviewLabel, overviewTV, videoButton)
  }

  private func layoutUI() {
    verticalSV.translatesAutoresizingMaskIntoConstraints = false
    overviewTV.translatesAutoresizingMaskIntoConstraints = false

    let padding: CGFloat = view.bounds.width * 0.05
    verticalSV.pinToSafeAreaEdgesOf(view, padding: padding)
    verticalSV.setCustomSpacingEqually(padding)

    NSLayoutConstraint.activate([
      posterIV.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2),
      posterIV.heightAnchor.constraint(equalTo: posterIV.widthAnchor, multiplier: 1.5),

      overviewTV.leadingAnchor.constraint(equalTo: verticalSV.leadingAnchor),
      overviewTV.trailingAnchor.constraint(equalTo: verticalSV.trailingAnchor),

      videoButton.heightAnchor.constraint(equalToConstant: 50),
      videoButton.leadingAnchor.constraint(equalTo: verticalSV.leadingAnchor),
      videoButton.trailingAnchor.constraint(equalTo: verticalSV.trailingAnchor)
    ])
  }
}


// MARK: UITextFieldDelegate
extension MovieVC: UITextViewDelegate { func textViewShouldBeginEditing(_ textView: UITextView) -> Bool { return false } }
