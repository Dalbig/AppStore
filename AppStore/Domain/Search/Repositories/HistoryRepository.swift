//
//  HistoryRepository.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/17.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol HistoryRepository: AnyObject {
    func getLatestHistory(limit: Int) -> SignalProducer<[History], AppStoreError>
    func getHistoriesWithKeyword(keyword: String) -> SignalProducer<[History], AppStoreError>
}
