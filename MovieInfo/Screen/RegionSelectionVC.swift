//
//  RegionSelectionVC.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 21/05/2021.
//

import UIKit

class RegionSelectionVC: UIViewController {

  private var regionCode: String?
  
  private var verticalSV = UIStackView()
  private var horizontalSV = UIStackView()

  private var apiAttributionView = MILogoAttribution()
  private var regionSelectionButton = MIButton.init(title: nil, isContrasted: true)
  private var upcomingMoviesButton = MIButton.init(title: Title.upcomingMovies)

  private var logoIV: UIImageView = {
    let imageView = UIImageView.init(image: Image.logo)
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()


  override func viewDidLoad() {
    super.viewDidLoad()

    addSubviews()

    view.backgroundColor = Color.background

    setupVerticalStackView()
    setupRegionSelectionButton()
    setupUpcomingMoviesButton()
    setuplogoView()

    setRegionButtonTitle(getCurrentRegion())
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }

  private func getCurrentRegion() -> String {
    let current = Locale.current
    regionCode = current.regionCode ?? ""

    return current.localizedString(forRegionCode: regionCode!) ?? "All"
  }

  private func setRegionButtonTitle(_ title: String) { regionSelectionButton.setTitle("→ Region: " + title + " ←", for: .normal) }

  private func addSubviews() {
    view.addSubview(verticalSV)
    verticalSV.addArrangedSubviews(logoIV, regionSelectionButton, upcomingMoviesButton, apiAttributionView)
  }

  private func setupVerticalStackView() {
    verticalSV.translatesAutoresizingMaskIntoConstraints = false

    verticalSV.axis = .vertical
    verticalSV.alignment = .center

    let padding = view.bounds.width / 10
    verticalSV.setCustomSpacingEqually(padding)
    verticalSV.pinToSafeAreaEdgesOf(view, padding: padding)
  }

  private func setuplogoView() {
    NSLayoutConstraint.activate([
      apiAttributionView.leadingAnchor.constraint(equalTo: verticalSV.leadingAnchor),
      apiAttributionView.trailingAnchor.constraint(equalTo: verticalSV.trailingAnchor)
    ])
  }

  private func setupRegionSelectionButton() {
    regionSelectionButton.addTarget(self, action: #selector(showRegionList), for: .touchUpInside)

    NSLayoutConstraint.activate([
      regionSelectionButton.widthAnchor.constraint(equalTo: verticalSV.widthAnchor),
      regionSelectionButton.heightAnchor.constraint(equalToConstant: 50)
    ])
  }

  private func setupUpcomingMoviesButton() {
    upcomingMoviesButton.addTarget(self, action: #selector(showUpcomingMoviesForRegion), for: .touchUpInside)

    NSLayoutConstraint.activate([
      upcomingMoviesButton.widthAnchor.constraint(equalTo: regionSelectionButton.widthAnchor),
      upcomingMoviesButton.heightAnchor.constraint(equalTo: regionSelectionButton.heightAnchor)
    ])
  }

  @objc func showRegionList() {
    let countryListVC = RegionListVC.init(style: .plain)
    countryListVC.delegate = self

    let navigationVC = UINavigationController.init(rootViewController: countryListVC)
    navigationVC.modalPresentationStyle = .pageSheet

    present(navigationVC, animated: true)
  }

  @objc func showUpcomingMoviesForRegion() {
    let upcomingMoviesVC = UpcomingMovieVC.init(title: Title.upcomingMovies, regionCode: regionCode)
    self.navigationController?.pushViewController(upcomingMoviesVC, animated: true)
  }
}


// MARK: CountryListVCDelegate
extension RegionSelectionVC: RegionListVCDelegate {

  func didSelectRegionCode(code: String?) {
    let regionName = Locale.current.localizedString(forRegionCode: code ?? "") ?? "All"
    setRegionButtonTitle(regionName)

    regionCode = code
    showUpcomingMoviesForRegion()
  }
}
