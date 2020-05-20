//
//  DevContext.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/18.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation

class ProdContext: CommonApplicationContext {
    override func configure() {
        /// Repositories
        registerLazySingleton({ return HistoryRealmRepository() as HistoryRepository })
        register({ return ItunesSearchRepository() as SearchRepository })

        /// UseCases
        register({ return SearchAppUseCase(searchRepository: self.resolve(), historyRepository: self.resolve()) })
        register({ return GetLatestHistoriesUseCase(historyRepository: self.resolve()) })
        register({ return GetHistoriesWithKeywordUseCase(historyRepository: self.resolve()) })
    }
}
