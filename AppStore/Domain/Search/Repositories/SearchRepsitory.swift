//
//  SearchRepsitory.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/17.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol SearchRepository: AnyObject {
    func search(term: String, limit: Int) -> SignalProducer<[AppContent], AppStoreError>
}
