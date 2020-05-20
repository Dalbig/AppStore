//
//  SearchInteractor.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/19.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation
import ReactiveSwift
protocol SearchBusinessLogic: AnyObject {
    func fetchLatestHistories()
    func searchApp(text: String)
}

class SearchInteractor: SearchBusinessLogic {
    var presenter: SearchPresentationLogic?
    private let disposables = CompositeDisposable()
    private let getLatestHistoriesUseCase: GetLatestHistoriesUseCase = Context.resolve()
    private let searchAppUseCase: SearchAppUseCase = Context.resolve()

    deinit {
        disposables.dispose()
    }

    func fetchLatestHistories() {
        disposables += getLatestHistoriesUseCase
            .execute()
            .startWithResult { [weak self] result in
                switch result {
                case .success(let data):
                    self?.presenter?.presentLatestHistories(histories: data.sorted(by: { $0.updatedDate > $1.updatedDate }))
                case .failure(let error):
                    print("failed to get latest histories : \(error.description)")
                }
        }
    }

    func searchApp(text: String) {
        disposables += searchAppUseCase.execute(param: text)
            .startWithResult { [weak self] result in
                switch result {
                case .success(let data):
                    self?.presenter?.presentApps(apps: data)
                case .failure(let error):
                    print("failed to get latest histories : \(error.description)")
                }
        }
    }
}
