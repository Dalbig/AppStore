//
//  PreviewCell.swift
//  AppStore
//
//  Created by Chanho Park on 2020/05/21.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation
import UIKit

class PreviewCell: DetailCollectionViewCell {
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!

    var screenshotUrls: [String] = []

    override class func awakeFromNib() {

    }

    override func configureCell(app: AppContent) {
        collectionViewLayout.minimumLineSpacing = 0
        
        
        screenshotUrls = app.screenshotUrls
    }

    private func calculateSectionInset() -> CGFloat {
        let deviceIsIpad = UIDevice.current.userInterfaceIdiom == .pad
        let deviceOrientationIsLandscape = UIDevice.current.orientation.isLandscape
        let cellBodyViewIsExpended = deviceIsIpad || deviceOrientationIsLandscape
        let cellBodyWidth: CGFloat = 236 + (cellBodyViewIsExpended ? 174 : 0)

        let buttonWidth: CGFloat = 50

        let inset = (collectionViewLayout.collectionView!.frame.width - cellBodyWidth + buttonWidth) / 4
        return inset
    }
}


extension PreviewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshotUrls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }


}
