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

    addSubviews()
    setupView()
    setupScrollView()
    setupContentView()
    setupVerticalStackView()

    setupSearchButton()
    setupSearchField()
    setuplogoView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
    registerKeyboardNotifications()
  }

  private func addSubviews() {
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(verticalSV)

    verticalSV.addArrangedSubviews(imageView, searchField, searchButton, logoView)
  }

  private func setupView() {
    view.backgroundColor = Color.background
    view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard)))
  }

  @objc func dismissKeyboard() {
    searchField.resignFirstResponder()
  }

  private func setupScrollView() {
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.pinToSafeAreaEdgesOf(view)
  }

  private func setupContentView() {
    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.pinToEdgesOf(scrollView)

    NSLayoutConstraint.activate([
      contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
      contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
    ])
  }

  private func setupVerticalStackView() {
    verticalSV.translatesAutoresizingMaskIntoConstraints = false

    verticalSV.axis = .vertical
    verticalSV.alignment = .center

    let padding = view.bounds.width / 10
    verticalSV.setCustomSpacingEqually(padding)
    verticalSV.pinToEdgesOf(contentView, padding: padding)
  }

  private func setupSearchField() {
    searchField.delegate = self

    // empty keyboard's shortcuts bar for ipads
    let item = searchField.inputAssistantItem
    item.leadingBarButtonGroups = []
    item.trailingBarButtonGroups = []

    NSLayoutConstraint.activate([
      searchField.widthAnchor.constraint(equalTo: verticalSV.widthAnchor),
      searchField.heightAnchor.constraint(equalToConstant: 50),
    ])
  }

  private func setupSearchButton() {
    searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)

    NSLayoutConstraint.activate([
      searchButton.widthAnchor.constraint(equalTo: searchField.widthAnchor),
      searchButton.heightAnchor.constraint(equalTo: searchField.heightAnchor)
    ])
  }

  @objc func searchButtonTapped() {
    if let text = searchField.text?.trimmingCharacters(in: .whitespacesAndNewlines), text.isEmpty {
      presentAlertOnMainQueue(title: "Empty Search", body: "Search field cannot be empty", buttonTittle: "Ok")
    }
    else {
      let movieGridVC = MovieGridVC()
      movieGridVC.title = searchField.text
      navigationController?.pushViewController(movieGridVC, animated: true)
    }

    searchField.text = ""
    dismissKeyboard()
  }
  
  private func setuplogoView() {
    NSLayoutConstraint.activate([
      logoView.leadingAnchor.constraint(equalTo: verticalSV.leadingAnchor),
      logoView.trailingAnchor.constraint(equalTo: verticalSV.trailingAnchor)
    ])
  }
}

// MARK: Keyboard will show and will hide notifications
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

// MARK: Keyboard delegate
extension SearchVC: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    searchButtonTapped()
    return true
  }
}
