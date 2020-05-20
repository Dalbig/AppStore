//
//  SearchPresenter.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/19.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation

protocol SearchPresentationLogic: AnyObject {
    func presentLatestHistories(histories: [History])
    func presentApps(apps: [AppContent])
}

class SearchPresenter: SearchPresentationLogic {
    weak var viewController: SearchDisplayLogic?

    func presentLatestHistories(histories: [History]) {
        let displayHistories = histories.map { Search.LatestHistory.ViewModel.History(term: $0.term, date: $0.updatedDate) }
        let viewModel = Search.LatestHistory.ViewModel(latestHistories: displayHistories)

        viewController?.displayLatestHistories(viewModel: viewModel)
    }

    func presentApps(apps: [AppContent]) {
        let apps = apps.map {
            Search.SearchedApp.ViewModel.App(trackName: $0.trackName, screenshotUrls: $0.screenshotUrls,
                artworkUrl100: $0.artworkUrl100,
                averageUserRatingForCurrentVersion: $0.averageUserRatingForCurrentVersion,
                userRatingCountForCurrentVersion: $0.userRatingCountForCurrentVersion,
                primaryGenreName: $0.primaryGenreName)
        }

        viewController?.displaySearchedApps(viewModel: Search.SearchedApp.ViewModel(apps: apps))
    }
}
