//
//  RegionListVC.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 20/05/2021.
//

import UIKit

protocol RegionListVCDelegate: AnyObject { func didSelectRegionCode(code: String?) }

class RegionListVC: UITableViewController {

  weak var delegate: RegionListVCDelegate!

  private var allRegions = [Region]()
  private var filteredRegions = [Region]()

  private var isKeyboardShowing = false


  override init(style: UITableView.Style) {
    super.init(style: style)

    setupTableView()
    setupNavigationBar()

    getRegions()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.setNavigationBarHidden(false, animated: true)
    navigationController?.navigationBar.prefersLargeTitles = false
  }

  private func getRegions() {
    let bottomOptions: [Region] = Locale.isoRegionCodes
      .map { Region(code: $0, name: Locale.current.localizedString(forRegionCode: $0)!) }
      .sorted { $0.name < $1.name }

    var regions = [ Region(code: nil, name: "All") ]
    regions.append(contentsOf: bottomOptions)

    self.allRegions = regions
    self.filteredRegions = regions
  }

  private func setupTableView() {
    tableView.register(CountryCell.self, forCellReuseIdentifier: CountryCell.reuseIdentifier)
    tableView.tableFooterView = UIView()

    clearsSelectionOnViewWillAppear = true
  }

  private func setupNavigationBar() {
    title = "Select Country"

    navigationItem.searchController = createSearchController()
    navigationItem.hidesSearchBarWhenScrolling = false

    navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(dismissController))
    navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: Image.top, style: .plain, target: self, action: #selector(scrollToTop))
  }

  private func createSearchController() -> UISearchController {
    let searchController = UISearchController()
    searchController.searchResultsUpdater = self
    searchController.searchBar.placeholder = "Search for a country"
    searchController.obscuresBackgroundDuringPresentation = false

    return searchController
  }

  @objc func scrollToTop() {
    guard filteredRegions.count > 0 else { return }
    tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
  }

  @objc func dismissController() { presentingViewController?.dismiss(animated: true) }
}


// MARK: UITableViewDelegate
extension RegionListVC {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return filteredRegions.count }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let country = filteredRegions[indexPath.row]

    let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.reuseIdentifier) as! CountryCell
    cell.setCell(country: country.name)
    
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let countryCode = filteredRegions[indexPath.row].code?.uppercased()
    delegate.didSelectRegionCode(code: countryCode)
    dismissController()
  }
}


// MARK: UISearchResultsUpdating
extension RegionListVC: UISearchResultsUpdating {

  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text else { return }

    let searchedCountry = text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    filteredRegions = searchedCountry.isEmpty ? allRegions : allRegions.filter { $0.name.lowercased().contains(searchedCountry) }
    
    tableView.reloadData()
  }
}
