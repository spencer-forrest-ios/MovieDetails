//
//  VideoVC.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 13/05/2021.
//

import UIKit

class VideoVC: UIViewController {

  private var video: Video!

  private var tableView: UITableView!


  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  convenience init(video: Video) {
    self.init(nibName: nil, bundle: nil)
    self.video = video
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    tableView.dataSource = self

    view.addSubview(tableView)
  }
}

// MARK: UITableViewDataSource
extension VideoVC: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return video.results.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: VideoCell.reuseIdentifier) as! VideoCell
    cell.set(title: video.results[indexPath.row].name)
    return cell
  }
}
