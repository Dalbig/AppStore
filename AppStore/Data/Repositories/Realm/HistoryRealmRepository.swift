//
//  SearchHistoryRealmRepositories.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/17.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveSwift


extension History: RealmEntityMapper {
    typealias REALM_ENTITY = HistoryRealmEntity
    func getRealmEntity() -> REALM_ENTITY {
        let mapper = HistoryRealmEntity()
        mapper.mapping(entity: self)
        return mapper
    }
}

class HistoryRealmEntity: Object, RealmEntity {
    typealias ENTITY = History
    var query: String = ""

    @objc dynamic var key: String = ""
    @objc dynamic var term: String = ""
    @objc dynamic var updatedDate: Double = 0

    override class func primaryKey() -> String? {
        return "key"
    }

    func mapping(entity: ENTITY) {
        key = entity.id
        term = entity.term
        updatedDate = entity.updatedDate
    }

    func getEntity() -> ENTITY {
        return History(id: key, term: term, updatedDate: updatedDate)
    }
}

class HistoryRealmRepository: CommonRealmDAO<History>, HistoryRepository {
    func AddHistories(histories: [History]) {
        do {
            try create(values: histories)
        } catch {
            if let error = error as? DAOError {
                print("exception error : \(error.description)")
            } else {
                print("exception error : \(error.localizedDescription)")
            }
        }
    }

    func deleteAllHistories() {
        do {
            try deleteAll()
        } catch {
            if let error = error as? DAOError {
                print("exception error : \(error.description)")
            } else {
                print("exception error : \(error.localizedDescription)")
            }
        }
    }

    func getLatestHistory(limit: Int) -> SignalProducer<[History], AppStoreError> {
        return self.readAll()
    }

    func getHistoriesWithKeyword(keyword: String) -> SignalProducer<[History], AppStoreError> {
        return self.readBegins(with: keyword)
    }
}
