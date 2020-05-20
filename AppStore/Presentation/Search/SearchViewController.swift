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
}

class SearchViewConroller: UIViewController {
    @IBOutlet weak var latestHistoryTableView: UITableView!
    var interactor: SearchBusinessLogic?
    var latestHistoriesViewModel: Search.LatestHistory.ViewModel?

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

        self.latestHistoryTableView.sectionHeaderHeight = 70
    }

    override func viewWillAppear(_ animated: Bool) {
        interactor?.fetchLatestHistories()
    }

    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true

        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension SearchViewConroller: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return latestHistoriesViewModel?.latestHistories.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let histories = latestHistoriesViewModel?.latestHistories else { return UITableViewCell() }

        let cell = UITableViewCell()
        cell.textLabel?.text = histories[indexPath.row].term
        cell.textLabel?.textColor = .systemBlue
        cell.textLabel?.sizeToFit()

        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
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
}

extension SearchViewConroller: SearchDisplayLogic {
    func displayLatestHistories(viewModel: Search.LatestHistory.ViewModel) {
        self.latestHistoriesViewModel = viewModel
        latestHistoryTableView.reloadData()
    }
}
