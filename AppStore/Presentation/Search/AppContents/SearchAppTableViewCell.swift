//
//  SearchAppTableViewCell.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/20.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation
import UIKit

class SearchAppTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var screenshotStackView: UIStackView!

    override func awakeFromNib() {

    }

    override func prepareForReuse() {
        ratingStackView.subviews.compactMap { $0 as? UIImageView }.forEach {
            $0.image = UIImage(systemName: "star")
        }
        screenshotStackView.subviews.compactMap { $0 as? UIImageView }.forEach { $0.image = nil }
        iconImageView.image = nil
    }

    func configureCell(app: Search.SearchedApp.ViewModel.App) {

        titleLabel.text = app.trackName
        subTitleLabel.text = app.primaryGenreName
        ratingCountLabel.text = getRatingCountString(count: app.userRatingCountForCurrentVersion)

        ImageManasger.downloadImage(url: app.artworkUrl100) { [weak self] image in
            DispatchQueue.main.async {
                self?.iconImageView.image = image
            }
        }

        let imageCount = app.screenshotUrls.count < 3 ? app.screenshotUrls.count : 3

        let screenImageViews = screenshotStackView.subviews.compactMap { $0 as? UIImageView }
        let ratingImageViews = ratingStackView.subviews.compactMap { $0 as? UIImageView }

        mapRatingToStar(views: ratingImageViews, rating: app.averageUserRatingForCurrentVersion)

        for n in 0..<imageCount {
            let url = app.screenshotUrls[n]
            ImageManasger.downloadImage(url: url) { image in
                DispatchQueue.main.async {
                    screenImageViews[n].image = image
                }
            }
        }
    }

    private func getRatingCountString(count: Int) -> String {
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

    private func mapRatingToStar(views: [UIImageView], rating: Double) {
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
