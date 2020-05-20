//
//  SearchViewModel.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/19.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation

enum Search {
    enum LatestHistory {
        struct ViewModel {
            struct History {
                let term: String
                let date: TimeInterval
            }
            var latestHistories: [History] = []
        }
    }

    enum HistoryWithKeyword {
        struct ViewModel {
            struct History {
                let term: String
                let date: TimeInterval
            }

            var histories: [History] = []
        }
    }

    enum SearchedApp {
        struct ViewModel {
            struct App {
                let trackName: String
                let screenshotUrls: [String]
                let artworkUrl100: String
                let averageUserRatingForCurrentVersion: Double
                let userRatingCountForCurrentVersion: Int
                let primaryGenreName: String
            }
            
            var apps: [App] = []
        }
    }
}
