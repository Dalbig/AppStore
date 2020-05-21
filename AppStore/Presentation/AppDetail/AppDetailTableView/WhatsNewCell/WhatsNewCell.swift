//
//  WhatsNewCell.swift
//  AppStore
//
//  Created by Chanho Park on 2020/05/21.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation
import UIKit

class WhatsNewCell: DetailCollectionViewCell {
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!

    override func awakeFromNib() {

    }

    override func prepareForReuse() {

    }

    override func configureCell(app: AppContent) {
        versionLabel.text = "Version " + app.version
        releaseDate.text = app.releaseDate
    }
}
