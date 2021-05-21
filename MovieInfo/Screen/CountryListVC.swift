//
//  CountryListVC.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 20/05/2021.
//

import UIKit

class CountryListVC: UITableViewController {

  private var allCountries = [Country]()
  private var countries = [Country]()


  override init(style: UITableView.Style) {
    super.init(style: style)

    setupTableView()
    setupNavigationBar()

    getCountries()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.setNavigationBarHidden(false, animated: true)
    navigationController?.navigationBar.prefersLargeTitles = false
  }

  private func getCountries() {
    guard let url = Bundle.main.url(forResource: Countries.fileName , withExtension: Countries.withExtension),
          let data = try? Data.init(contentsOf: url),
          let countries = try? JSONDecoder().decode([Country].self, from: data) else { return }

    self.allCountries = countries
    self.countries = countries
  }

  private func setupTableView() {
    tableView.register(CountryCell.self, forCellReuseIdentifier: CountryCell.reuseIdentifier)
    tableView.tableFooterView = UIView()

    clearsSelectionOnViewWillAppear = true
  }

  private func setupNavigationBar() {
    title = "Select Country"

    navigationItem.searchController = createSearchController()
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
    guard countries.count > 0 else { return }
    tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
  }
}


// MARK: UITableViewDelegate
extension CountryListVC {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return countries.count }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let country = countries[indexPath.row]

    let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.reuseIdentifier) as! CountryCell
    cell.setCell(country: country.name)
    
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let countryCode = countries[indexPath.row].code?.uppercased()

    let popularVC = PopularVC.init(title: "Popular in \(Date.getCurrentYearAsString())", countryCode: countryCode)
    self.navigationController?.pushViewController(popularVC, animated: true)

    let searchController = navigationItem.searchController
    searchController?.searchBar.text = nil
    searchController?.dismiss(animated: false)
  }
}


// MARK: UISearchResultsUpdating
extension CountryListVC: UISearchResultsUpdating {

  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text else { return }

    let searchedCountry = text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

    if searchedCountry.isEmpty {
      countries = allCountries
      tableView.reloadData()
    } else {
      countries = allCountries.filter { $0.name.lowercased().contains(searchedCountry) }
      tableView.reloadData()
    }
  }
}
