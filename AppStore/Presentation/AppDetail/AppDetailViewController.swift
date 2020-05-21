//
//  AppDetailViewController.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/21.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation
import UIKit



class AppDetailViewController: UIViewController {
    var app: AppContent?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        setupNavBar()

        tableView.estimatedRowHeight = 250
        tableView.rowHeight = UITableView.automaticDimension

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DescriptionCell", bundle: nil), forCellReuseIdentifier: "DescriptionCell")
    }

    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    func addNavBarItems() {
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 20))

        rightButton.layer.cornerRadius = 15
        rightButton.backgroundColor = .systemBlue
        rightButton.setTitle("GET", for: .normal)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)

        if let url = app?.artworkUrl60 {
            ImageManasger.downloadImage(url: url) { [weak self] image in
                DispatchQueue.main.async {

                    let imageButton = UIButton(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
                    imageButton.imageView?.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
                    imageButton.imageView?.layer.cornerRadius = 20
                    imageButton.imageView?.contentMode = .scaleAspectFit
                    imageButton.setImage(image, for: .normal)
//                    imageButton.imageView?.image?.withAlignmentRectInsets(UIEdgeInsets(top: -4, left: -4, bottom: -4, right: -4))

                    self?.navigationItem.titleView = imageButton
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDetailCellType.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()

//        guard let row = AppDetailCellType(rawValue: indexPath.row) else {
//            return UITableViewCell()
//        }
//
//        guard let app = app, let cell = row.getTableViewCell(tableView: tableView, indexPath: indexPath) else {
//            return UITableViewCell()
//        }
//
//        cell.configureCell(app: app)
//        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let section = AppDetailCellType(rawValue: indexPath.section) else { return 50 }
//
//        return section.height
//    }

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.panGestureRecognizer.translation(in: scrollView).y < -200 {
//            addNavBarItems()
//        } else {
//            deleteNavBarItems()
//        }
//    }
}
