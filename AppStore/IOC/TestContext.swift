//
//  TestContext.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/18.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation

class TestContext: CommonApplicationContext {
    override func configure() {
        /// Repositories
        register({ return MockHistoryRealmRepository() as HistoryRepository })
        register({ return MockItunesSearchRepository() as SearchRepository })

        /// UseCases
        register({ return SearchAppUseCase(searchRepository: self.resolve()) })
    }
}
