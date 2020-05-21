//
//  DetailViewController.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/21.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation
import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    func configureCell(app: AppContent) {

    }
}


enum AppDetailCellType: Int, CaseIterable {
    case header = 0
    case whatsNew = 1
    case preview = 2
    case description = 3
    case information = 4

    var height: CGFloat {
        switch self {
        case .header: return 250
        case .whatsNew: return 100
        case .preview: return 400
        case .description: return 400
        case .information: return 0
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

    func getCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath) -> DetailCollectionViewCell? {
        switch self {
        case .header:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)as? AppHeaderCell
            return cell
        case .whatsNew:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)as? WhatsNewCell
            return cell
//        case .preview:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)as? PreviewCell
//            return cell
//        case .description:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)as? DescriptionCell
//            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)as? AppHeaderCell
            return cell
        }
    }
}


class DetailViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var app: AppContent?


    override func viewDidLoad() {
        self.collectionView.register(UINib(nibName: "AppHeaderCell", bundle: nil), forCellWithReuseIdentifier: "AppHeaderCell")
        self.collectionView.register(UINib(nibName: "WhatsNewCell", bundle: nil), forCellWithReuseIdentifier: "WhatsNewCell")

    }
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let type = AppDetailCellType(rawValue: indexPath.item)

        let cell = type?.getCollectionViewCell(collectionView: collectionView, indexPath: indexPath)

        cell?.configureCell(app: app!)

        return cell!
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let type = AppDetailCellType(rawValue: indexPath.item) else { return CGSize.zero }
        
        let width = collectionView.bounds.size.width

        return CGSize(width: width , height: type.height)
    }
}
