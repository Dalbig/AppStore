//
//  SearchViewController.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/19.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation
import UIKit

protocol SearchDisplayLogic: AnyObject {
    func displayLatestHistories(viewModel: Search.LatestHistory.ViewModel)
    func displaySearchedApps(viewModel: Search.SearchedApp.ViewModel)
}

protocol SearchResultDeletate: AnyObject {
    func didSelectItem(text: String)
}

class SearchViewConroller: UIViewController {
    @IBOutlet weak var latestHistoryTableView: UITableView!
    private let searchResultsController = ResultsController(style: .plain)

    @IBOutlet weak var searchAppsTableView: SearchTableView!
    var interactor: SearchBusinessLogic?
    var histories: [Search.LatestHistory.ViewModel.History] = []
    var viewModel: Search.SearchedApp.ViewModel?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup()
    {
        let viewController = self
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }

    override func viewDidLoad() {
        setupNavBar()
        let nib = UINib(nibName: "SearchAppTableViewCell", bundle: nil)
        self.searchAppsTableView.register(nib, forCellReuseIdentifier: "SearchAppTableViewCell")
        self.latestHistoryTableView.sectionHeaderHeight = 70
        self.searchResultsController.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        interactor?.fetchLatestHistories()
    }

    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true

        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController
        searchController.delegate = self
        searchController.searchBar.placeholder = "Games, Apps, Stories and More"
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension SearchViewConroller: SearchDisplayLogic {
    func displayLatestHistories(viewModel: Search.LatestHistory.ViewModel) {
        self.histories = viewModel.latestHistories
        self.searchResultsController.histories = viewModel.latestHistories

        DispatchQueue.main.async {
            self.latestHistoryTableView.reloadData()
        }
    }

    func displaySearchedApps(viewModel: Search.SearchedApp.ViewModel) {
        self.viewModel = viewModel

        DispatchQueue.main.async {
            self.latestHistoryTableView.isHidden = true
            self.searchAppsTableView.isHidden = false
            self.searchAppsTableView.reloadData()
        }
    }
}

extension SearchViewConroller: SearchResultDeletate {
    func didSelectItem(text: String) {
        navigationItem.searchController?.showsSearchResultsController = false
        navigationItem.searchController?.searchBar.text = text
        interactor?.searchApp(text: text)
    }

}

extension SearchViewConroller: UISearchControllerDelegate, UISearchBarDelegate {
    func willDismissSearchController(_ searchController: UISearchController) {
        self.latestHistoryTableView.isHidden = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.latestHistoryTableView.isHidden = false
        self.searchAppsTableView.isHidden = true

        interactor?.fetchLatestHistories()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        navigationItem.searchController?.showsSearchResultsController = false
        interactor?.searchApp(text: text)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filtered = histories.filter { $0.term.lowercased().contains(searchText.lowercased()) }

        guard filtered.isEmpty else { return }
        navigationItem.searchController?.showsSearchResultsController = true
    }
}

extension SearchViewConroller: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView is SearchTableView {
            let count = viewModel?.apps.count ?? 0

            if count == 0 {
                tableView.separatorStyle = .none
            } else {
                tableView.separatorStyle = .singleLine
            }

            return count
        } else {
            return histories.count
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView is SearchTableView {
            return 350
        } else {
            return 50
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView is SearchTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchAppTableViewCell", for: indexPath) as? SearchAppTableViewCell,
                let app = viewModel?.apps[indexPath.row] else {
                    return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configureCell(app: app)
            return cell
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = histories[indexPath.row].term
            cell.textLabel?.textColor = .systemBlue
            cell.textLabel?.sizeToFit()
            cell.selectionStyle = .none

            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView is SearchTableView {
            return 0
        } else {
            return 60
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 60))

        let label = UILabel()
        label.frame = CGRect.init(x: 15, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
        label.text = "최근 검색어"
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = .black

        headerView.addSubview(label)

        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView is SearchTableView {
        } else {
            let text = histories[indexPath.row].term
            interactor?.searchApp(text: text)
            navigationItem.searchController?.isActive = true
            navigationItem.searchController?.showsSearchResultsController = false
            navigationItem.searchController?.searchBar.text = text
        }
    }
}

class ResultsController: UITableViewController, UISearchResultsUpdating {
    var histories: [Search.LatestHistory.ViewModel.History] = []
    private var filteredHistories: [Search.LatestHistory.ViewModel.History] = []
    private var searchText: String = ""

    weak var delegate: SearchResultDeletate?

    override func viewDidLoad() {

    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }

        filterContentForSearchText(text)
    }

    func filterContentForSearchText(_ searchText: String) {
        self.searchText = searchText
        self.filteredHistories = histories.filter { $0.term.lowercased().contains(searchText.lowercased()) }
        
        if self.filteredHistories.isEmpty {
            tableView.separatorStyle = .none
        } else {
            tableView.separatorStyle = .singleLine
        }

        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredHistories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = filteredHistories[indexPath.row].term
        cell.textLabel?.sizeToFit()
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let term = filteredHistories[indexPath.row].term
        delegate?.didSelectItem(text: term)
    }
}


