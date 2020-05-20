//
//  SearchPresenter.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/19.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation

protocol SearchPresentationLogic: AnyObject {
    func presentLatestHistories(histories: [History])
}

class SearchPresenter: SearchPresentationLogic {
    weak var viewController: SearchDisplayLogic?

    func presentLatestHistories(histories: [History]) {
        let displayHistories = histories.map { Search.LatestHistory.ViewModel.History(term: $0.term, date: $0.updatedDate) }
        let viewModel = Search.LatestHistory.ViewModel(latestHistories: displayHistories)
        
        viewController?.displayLatestHistories(viewModel: viewModel)
    }
}
