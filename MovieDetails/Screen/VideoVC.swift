//
//  VideoVC.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 13/05/2021.
//

import UIKit
import SafariServices

class VideoVC: NavigationRightBarButtonVC {

  private var video: Video!
  private var tableView: UITableView!


  override init(movie: MovieData) { super.init(movie: movie) }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  convenience init(video: Video, movie: MovieData) {
    self.init(movie: movie)
    self.video = video
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
  }
  
  private func setupTableView() {
    tableView = UITableView.init(frame: view.bounds)
    tableView.register(VideoCell.self, forCellReuseIdentifier: VideoCell.reuseIdentifier)

    tableView.rowHeight = 80
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.backgroundColor = Color.background

    tableView.dataSource = self
    tableView.delegate = self

    view.addSubview(tableView)
  }
}


// MARK: UITableViewDataSource
extension VideoVC: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return video.results.count }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: VideoCell.reuseIdentifier) as! VideoCell
    cell.set(title: video.results[indexPath.row].name)
    return cell
  }
}


// MARK: UITableViewDelegate
extension VideoVC: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let video = video.results[indexPath.row]

    let isUsingYoutube = video.site.lowercased() == Site.youtube
    let webUrl = isUsingYoutube ? URL.init(string: Site.youtubeURLString + video.key)! :  URL.init(string: Site.vimeoURLString + video.key)!
    let appUrl = isUsingYoutube ? URL.init(string: Site.youtubeAppURLString + video.key)! : URL.init(string: Site.vimeoAppUrlstring + video.key)!

    openVideo(appUrl: appUrl, webUrl: webUrl)
  }

  /// Try opening URL using the app 'vimeo' or 'youtube'.
  /// Othewise, use embedded safari web brower to open it.
  ///
  /// - Parameters:
  ///   - appUrl: url needed to open video with the corresponding app
  ///   - webUrl: url needed to open video via safari
  private func openVideo(appUrl: URL, webUrl: URL) {
    if UIApplication.shared.canOpenURL(appUrl)  {
      UIApplication.shared.open(appUrl, options: [:], completionHandler: nil)
    } else {
      presentSafariController(url: webUrl)
    }
  }

  private func presentSafariController(url: URL) {
    let application = UIApplication.shared.delegate as! AppDelegate
    application.appOrientation = .allButUpsideDown

    let config = SFSafariViewController.Configuration()
    config.entersReaderIfAvailable = false
    config.barCollapsingEnabled = false

    let safariController = SFSafariViewController.init(url: url, configuration: config)
    safariController.dismissButtonStyle = .close
    safariController.modalPresentationStyle = .fullScreen
    safariController.delegate = self

    present(safariController, animated: true)
  }
}


// MARK: SFSafariViewControllerDelegate
extension VideoVC: SFSafariViewControllerDelegate {

  func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    let application = UIApplication.shared.delegate as! AppDelegate
    application.appOrientation = .portrait
  }
}
