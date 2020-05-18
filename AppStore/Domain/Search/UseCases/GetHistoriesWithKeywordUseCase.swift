//
//  GetHistoriesWithKeyword.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/17.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation
import ReactiveSwift

class GetHistoriesWithKeywordUseCase: UseCaseWithParam {
    typealias Param = String
    typealias Result = [History]

    private var historyRepository: HistoryRepository!

    init(historyRepository: HistoryRepository) {
        self.historyRepository = historyRepository
    }

    func execute(param: String) -> SignalProducer<Result, AppStoreError> {
        return historyRepository.getHistoriesWithKeyword(keyword: param)
    }
}
