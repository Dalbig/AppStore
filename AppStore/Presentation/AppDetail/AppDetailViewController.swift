//
//  AppDetailViewController.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/21.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation
import UIKit

class DetailTableViewCell: UITableViewCell {
    func configureCell(app: AppContent) {

    }
}

enum AppDetailSection: Int, CaseIterable {
    case header
    case whatsNew
    case preview
    case description
    case information

    var height: CGFloat {
        switch self {
        case .header: return 250
        case .whatsNew: return 100
        case .preview: return 400
        case .description: return 400
        case .information: return 0
        }
    }

    var headerName: String {
        switch self {
        case .header: return ""
        case .whatsNew: return "What's New"
        case .preview: return "Preview"
        case .description: return ""
        case .information: return "Information"
        }
    }

    var reuseIdentifier: String {
        switch self {
        case .header: return "AppHeaderCell"
        case .whatsNew: return "WhatsNewCell"
        case .preview: return "PreviewCell"
        case .description: return "DescriptionCell"
        case .information: return "AppHeaderCell"
        }
    }

    func getTableViewCell(tableView: UITableView, indexPath: IndexPath) -> DetailTableViewCell? {
        switch self {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)as? AppHeaderCell
            return cell
        case .whatsNew:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)as? WhatsNewCell
            return cell
        case .preview:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)as? PreviewCell
            return cell
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)as? DescriptionCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)as? AppHeaderCell
            return cell
        }
    }
}

class AppDetailViewController: UIViewController {
    var app: AppContent?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        setupNavBar()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AppHeaderCell", bundle: nil), forCellReuseIdentifier: "AppHeaderCell")
        tableView.register(UINib(nibName: "WhatsNewCell", bundle: nil), forCellReuseIdentifier: "WhatsNewCell")
        tableView.register(UINib(nibName: "PreviewCell", bundle: nil), forCellReuseIdentifier: "PreviewCell")
        tableView.register(UINib(nibName: "DescriptionCell", bundle: nil), forCellReuseIdentifier: "DescriptionCell")
    }

    func setupNavBar() {


        navigationController?.navigationBar.prefersLargeTitles = false
    }

    func addNavBarItems() {
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 20))

        rightButton.layer.cornerRadius = 15
        rightButton.backgroundColor = .systemBlue
        rightButton.titleLabel?.text = "GET"

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)

        if let url = app?.artworkUrl60 {
            ImageManasger.downloadImage(url: url) { [weak self] image in
                DispatchQueue.main.async {
                    let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                    view.layer.cornerRadius = 15
                    view.image = image

                    self?.navigationItem.titleView = view
                }
            }
        }
    }

    func deleteNavBarItems() {
        navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = nil
    }
}

extension AppDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return AppDetailSection.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let section = AppDetailSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        guard let app = app, let cell = section.getTableViewCell(tableView: tableView, indexPath: indexPath) else {
            return UITableViewCell()
        }

        cell.configureCell(app: app)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = AppDetailSection(rawValue: indexPath.section) else { return 50 }

        return section.height
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = AppDetailSection(rawValue: section) else { return 0 }

        if section.headerName.isEmpty {
            return 0
        }

        return 60
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = AppDetailSection(rawValue: section) else { return nil }

        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 60))
        let label = UILabel()
        label.frame = CGRect.init(x: 15, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
        label.text = section.headerName
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        headerView.addSubview(label)

        headerView.backgroundColor = .systemBackground
        return headerView
    }


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            addNavBarItems()
        } else {
            deleteNavBarItems()
        }
    }
}
