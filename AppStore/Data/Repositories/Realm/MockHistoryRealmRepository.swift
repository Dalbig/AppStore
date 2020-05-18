//
//  MokSearchHistoryRealmRepository.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/17.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation
import ReactiveSwift

class MockHistoryRealmRepository: HistoryRepository {
    func getLatestHistory(limit: Int) -> SignalProducer<[History], AppStoreError> {
        return SignalProducer(error: .failure(reason: "none"))

    }

    func getHistoriesWithKeyword(keyword: String) -> SignalProducer<[History], AppStoreError> {
        return SignalProducer(error: .failure(reason: "none"))

    }
}
