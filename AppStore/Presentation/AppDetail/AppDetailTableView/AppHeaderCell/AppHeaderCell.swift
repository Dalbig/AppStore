//
//  AppHeaderCell.swift
//  AppStore
//
//  Created by Chanho Park on 2020/05/21.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation
import UIKit

class AppHeaderCell: DetailTableViewCell {
    @IBOutlet var upperWraperView: UIView!

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!

    @IBOutlet var ratingStackView: UIStackView!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var ratingCountLabel: UILabel!

    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var primaryGenre: UILabel!
    @IBOutlet var ageLabel: UILabel!


    override func awakeFromNib() {

    }

    override func prepareForReuse() {

    }

    override func configureCell(app: AppContent) {
        ImageManasger.downloadImage(url: app.artworkUrl512) { [weak self] image in
            DispatchQueue.main.async {
                self?.iconImageView.image = image
            }
        }

        titleLabel.text = app.trackName
        subTitleLabel.text = app.artistName

        primaryGenre.text = app.primaryGenreName
        ageLabel.text = app.contentAdvisoryRating

        let ratingImageViews = ratingStackView.subviews.compactMap { $0 as? UIImageView }

        mapRatingToStar(views: ratingImageViews, rating: app.averageUserRatingForCurrentVersion)

        ratingCountLabel.text = getRatingCountString(count: app.userRatingCountForCurrentVersion) + " rating"
    }
}
