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
    func AddHistories(histories: [History]) {

    }

    func deleteAllHistories() {

    }

    func getLatestHistory(limit: Int) -> SignalProducer<[History], AppStoreError> {
        return SignalProducer(value: getDummyHistories())

    }

    func getHistoriesWithKeyword(keyword: String) -> SignalProducer<[History], AppStoreError> {
        return SignalProducer(value: getDummyHistories())
    }

    private func getDummyHistories() -> [History] {
        return [
            History(id: "카프리선", term: "카카오톡", updatedDate: Date().timeIntervalSince1970),
            History(id: "카카오", term: "카카오톡", updatedDate: Date().timeIntervalSince1970),
            History(id: "카카오뱅크", term: "카카오톡", updatedDate: Date().timeIntervalSince1970),
            History(id: "카카오ㅇㅇ", term: "카카오톡", updatedDate: Date().timeIntervalSince1970),
            History(id: "카카오 ㅍㅊ", term: "카카오톡", updatedDate: Date().timeIntervalSince1970),
            History(id: "카카오ㄷㄱ", term: "카카오톡", updatedDate: Date().timeIntervalSince1970),
            History(id: "카카오치즈", term: "카카오톡", updatedDate: Date().timeIntervalSince1970),
            History(id: "카카옽", term: "카카오톡", updatedDate: Date().timeIntervalSince1970),
        ]
    }
}
