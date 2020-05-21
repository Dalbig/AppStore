//
//  DescriptionCell.swift
//  AppStore
//
//  Created by Chanho Park on 2020/05/21.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation
import UIKit

class DescriptionCell: DetailCollectionViewCell {
    @IBOutlet weak var descLabel: UILabel!
    
    override func configureCell(app: AppContent) {
        descLabel.text = app.description
    }
}
