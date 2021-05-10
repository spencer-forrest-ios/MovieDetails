//
//  SearchVC.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 08/05/2021.
//

import UIKit

class SearchVC: UIViewController {

  private var scrollView = UIScrollView()
  private var contentView = UIView()
  private var verticalSV = UIStackView()

  private var searchField = MITextField()
  private var searchButton = MIButton.init(title: "Search")
  private var logoView = MILogoAttribution()

  private var imageView: UIImageView = {
    let imageView = UIImageView.init(image: Image.logo)
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  
  override func viewDidLoad() {
    super.viewDidLoad()

    configureViewController()
    configureVerticalStackView()

    layoutUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    registerKeyboardNotifications()
  }

  private func configureViewController() {
    navigationController?.setNavigationBarHidden(true, animated: true)
    view.backgroundColor = .systemBackground

    view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard)))
  }


  @objc func dismissKeyboard() {
    searchField.resignFirstResponder()
  }


  private func configureVerticalStackView() {
    verticalSV.axis = .vertical
    verticalSV.alignment = .center
  }


  private func layoutUI() {
    addSubviews()

    layoutScrollView()
    layoutContentView()
    layoutVerticalStackView()

    layoutSearchButton()
    layoutSearchField()
    layoutlogoView()
  }


  private func addSubviews() {
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(verticalSV)

    verticalSV.addArrangedSubviews([imageView, searchField, searchButton, logoView])
  }


  private func layoutScrollView() {
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.pinToSafeAreaEdgesOf(view)
  }


  private func layoutContentView() {
    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.pinToEdgesOf(scrollView)

    NSLayoutConstraint.activate([
      contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
      contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
    ])
  }


  private func layoutSearchField() {
    NSLayoutConstraint.activate([
      searchField.widthAnchor.constraint(equalTo: verticalSV.widthAnchor),
      searchField.heightAnchor.constraint(equalToConstant: 50),
    ])
  }


  private func layoutSearchButton() {
    NSLayoutConstraint.activate([
      searchButton.widthAnchor.constraint(equalTo: searchField.widthAnchor),
      searchButton.heightAnchor.constraint(equalTo: searchField.heightAnchor)
    ])
  }


  private func layoutlogoView() {
    NSLayoutConstraint.activate([
      logoView.leadingAnchor.constraint(equalTo: verticalSV.leadingAnchor),
      logoView.trailingAnchor.constraint(equalTo: verticalSV.trailingAnchor)
    ])
  }


  private func layoutVerticalStackView() {
    verticalSV.translatesAutoresizingMaskIntoConstraints = false

    let padding = view.bounds.width / 10
    verticalSV.setCustomSpacingEqually(padding)
    verticalSV.pinToEdgesOf(contentView, padding: padding)
  }
}

// MARK: Keyboard did show notification
extension SearchVC {
  private func registerKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(expandScrollView), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(reduceScrollView), name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  @objc func expandScrollView(_ notification: Notification) {
    guard var keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue) as? CGRect else { return }

    keyboardFrame = view.convert(keyboardFrame, from: view.window)

    let heightOverlap = scrollView.frame.maxY - keyboardFrame.origin.y

    scrollView.setContentOffset(CGPoint.init(x: 0, y: heightOverlap), animated: true)
    scrollView.verticalScrollIndicatorInsets.bottom = heightOverlap
    scrollView.contentInset.bottom = heightOverlap
  }

  @objc func reduceScrollView() {
    scrollView.setContentOffset(.zero, animated: true)
    scrollView.verticalScrollIndicatorInsets.bottom = .zero
    scrollView.contentInset.bottom = .zero
  }
}
