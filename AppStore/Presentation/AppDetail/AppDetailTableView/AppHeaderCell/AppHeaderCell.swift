//
//  AppHeaderCell.swift
//  AppStore
//
//  Created by Chanho Park on 2020/05/21.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation
import UIKit

class AppHeaderCell: DetailCollectionViewCell {
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
    
    func getRatingCountString(count: Int) -> String {
        let ratingCountUpper = Int(count / 1000)
        let ratingCountDown = (count % 1000)

        var raingCount: String = ""

        if (ratingCountUpper / 10) > 0 {
            //두자리 이상
            raingCount = "\(ratingCountUpper)k"
        } else if ratingCountUpper > 0 {
            raingCount = "\(ratingCountUpper).\(Int(ratingCountDown / 100))k"
        } else {
            raingCount = "\(ratingCountDown)"
        }

        return raingCount
    }

    func mapRatingToStar(views: [UIImageView], rating: Double) {
        let upperRating = Int(rating)
        let downRating = rating - Double(upperRating)

        for n in 0..<upperRating {
            views[n].image = UIImage(systemName: "star.fill")
        }

        if upperRating == 5 { return }

        if downRating >= 0.7 && downRating <= 0.9 {
            views[upperRating].image = UIImage(systemName: "star.fill")
        } else if downRating >= 0.4 && downRating <= 0.6 {
            views[upperRating].image = UIImage(systemName: "star.lefthalf.fill")
        }
    }
}
