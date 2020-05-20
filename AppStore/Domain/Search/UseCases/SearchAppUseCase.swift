//
//  SearchApp.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/17.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation
import ReactiveSwift

class SearchAppUseCase: UseCaseWithParam {
    typealias Param = String
    typealias Result = [AppContent]
    private let limit = 100

    private var searchRepository: SearchRepository!
    private var historyRepository: HistoryRepository!

    init(searchRepository: SearchRepository, historyRepository: HistoryRepository) {
        self.searchRepository = searchRepository
        self.historyRepository = historyRepository
    }

    func execute(param: String) -> SignalProducer<Result, AppStoreError> {
        historyRepository.AddHistories(histories: [History(id: param, term: param, updatedDate: Date().timeIntervalSince1970)])
        return searchRepository.search(term: param, limit: limit)
    }
}
