//
//  GetLatestHistories.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/17.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation
import ReactiveSwift

class GetLatestHistoriesUseCase: UseCase {
    typealias Result = [History]
    private let limit = 30
    private var historyRepository: HistoryRepository!
    
    init(historyRepository: HistoryRepository) {
        self.historyRepository = historyRepository
    }

    func execute() -> SignalProducer<Result, AppStoreError> {
        return historyRepository.getLatestHistory(limit: limit)
    }
}
