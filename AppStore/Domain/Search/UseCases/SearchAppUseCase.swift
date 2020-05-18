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

    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }

    func execute(param: String) -> SignalProducer<Result, AppStoreError> {
        return searchRepository.search(term: param, limit: limit)
    }
}
