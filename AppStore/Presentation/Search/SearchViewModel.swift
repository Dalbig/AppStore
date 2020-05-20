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
            let term: String
            let date: TimeInterval
        }
    }

    enum SearchedApp {
        struct ViewModel {

        }
    }
}
