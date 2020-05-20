//
//  CommonRealmDAO.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/19.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveSwift

enum DAOError: Error {
    case createFail(String)
    case readFail(String)
    case deleteFail(String)

    var description: String {
        switch self {
        case .createFail(let reason): return "create : \(reason)"
        case .readFail(let reason): return "read : \(reason)"
        case .deleteFail(let reason): return "delete : \(reason)"
        }
    }
}

protocol DAO {
    associatedtype KEY
    associatedtype VALUE

    func create(value: VALUE) throws
    func read(key: KEY) -> SignalProducer<VALUE?, AppStoreError>
    func readBegins(with key: KEY) -> SignalProducer<[VALUE], AppStoreError>
    func readAll() -> SignalProducer<[VALUE], AppStoreError>
    func delete(key: KEY) throws
    func deleteAll() throws
}

protocol RealmEntity {
    associatedtype ENTITY
    var query: String { get set }
    func mapping(entity: ENTITY)
    func getEntity() -> ENTITY
}

protocol RealmEntityMapper {
    associatedtype REALM_ENTITY
    func getRealmEntity() -> REALM_ENTITY
}

class CommonRealmDAO<VALUE: RealmEntityMapper>: NSObject, DAO where VALUE.REALM_ENTITY: Object, VALUE.REALM_ENTITY: RealmEntity {
    private class func getConfiguration() -> Realm.Configuration {
        return Realm.Configuration(
            fileURL: CommonRealmDAO.reamlFileUrl(for: "appstore.realm"),
            schemaVersion: 1,
            migrationBlock: { _, _ in },
            deleteRealmIfMigrationNeeded: true,
            shouldCompactOnLaunch: { (_, _) in return true },
            objectTypes: [HistoryRealmEntity.self])
    }

    private class func reamlFileUrl(for name: String) -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let documentDirectory = urls.first {
            return documentDirectory.appendingPathComponent(name)
        }

        return Realm.Configuration.defaultConfiguration.fileURL!
    }

    internal var rwRealm: Realm? {
        assert(Thread.current == _thread)
        if _rwRealm == nil {
            _rwRealm = CommonRealmDAO.getRealm()
        }
        return _rwRealm
    }

    private var _rwRealm: Realm?

    typealias KEY = String

    /// ensure thread safety
    private let condition = NSCondition()

    private var _thread: RealmThread?

    /// Used to control the access to the model data
    internal var thread: RealmThread {
        condition.lock()
        if _thread == nil {
            _thread = RealmThread()
        }
        condition.unlock()
        return _thread!
    }

    internal class func getRealm() -> Realm {
        var realm: Realm!
        do {
            realm = try Realm(configuration: CommonRealmDAO.getConfiguration())
        } catch {
            print(" realm created failed")
        }
        return realm
    }

    override init() {
        super.init()
        print("init")
    }

    deinit {
        stop()
        print("deinit")
    }

    func getRealmConfig() -> Realm.Configuration {
        return Realm.Configuration()
    }

    func create(value: VALUE) throws {
        async { [weak self] in
            do {
                guard let self = self,
                    let realm = self.rwRealm else {
                        return
                }

                try realm.write {
                    realm.add(value.getRealmEntity(), update: .all)
                }
            } catch let error as NSError {
                throw DAOError.createFail(error.description)
            }
        }
    }

    func create(values: [VALUE]) throws {
        async { [weak self] in
            do {
                guard let self = self,
                    let realm = self.rwRealm else {
                        return
                }

                try realm.write {
                    let realmEntityList = values.map { $0.getRealmEntity() }
                    realm.add(realmEntityList, update: .all)
                }
            } catch let error as NSError {
                throw DAOError.createFail(error.description)
            }
        }
    }

    func readAll() -> SignalProducer<[VALUE], AppStoreError> {
        return readAllEntity().map { realmEntity -> [VALUE] in
            return realmEntity.map { $0.getEntity() as? VALUE }.compactMap { $0 }
        }
    }

    func read(key: KEY) -> SignalProducer<VALUE?, AppStoreError> {
        return readEntity(key: key).map { realmEntity -> VALUE? in
            guard let result = realmEntity.getEntity() as? VALUE else {
                return nil
            }

            return result
        }
    }

    func readBegins(with key: KEY) -> SignalProducer<[VALUE], AppStoreError> {
        return readEntity(beginsWith: key).map { realmEntity -> [VALUE] in
            return realmEntity.map { $0.getEntity() as? VALUE }.compactMap { $0 }
        }
    }

    func delete(key: KEY) throws {
        async { [weak self] in
            do {
                guard let self = self,
                    let realm = self.rwRealm else {
                        return
                }

                try realm.write {
                    guard let result = realm.object(ofType: VALUE.REALM_ENTITY.self, forPrimaryKey: key) else {
                        return
                    }

                    realm.delete(result)
                }
            } catch let error as NSError {
                throw DAOError.deleteFail(error.description)
            }
        }
    }

    func delete(keys: [KEY]) {
        async { [weak self] in
            do {
                guard let self = self,
                    let realm = self.rwRealm else {
                        return
                }

                try realm.write {
                    keys.forEach { key in
                        guard let result = realm.object(ofType: VALUE.REALM_ENTITY.self, forPrimaryKey: key) else {
                            return
                        }
                        realm.delete(result)
                    }
                }
            } catch let error as NSError {
                throw DAOError.deleteFail(error.description)
            }
        }
    }

    func deleteAll() throws {
        async { [weak self] in
            do {
                guard let self = self,
                    let realm = self.rwRealm else {
                        return
                }

                try realm.write {
                    realm.deleteAll()
                }
            } catch let error as NSError {
                throw DAOError.deleteFail(error.description)
            }
        }
    }
}

extension CommonRealmDAO {
    fileprivate func readEntity(beginsWith: String) -> SignalProducer<[VALUE.REALM_ENTITY], AppStoreError> {
        return SignalProducer { [weak self] observer, disposable in
            self?.async { [weak self] in
                guard let self = self,
                    let realm = self.rwRealm else {
                        observer.send(error: .failure(reason: "failed to get realm"))
                        return
                }

                let result = realm.objects(VALUE.REALM_ENTITY.self)
                let filterString = "key BEGINSWITH '\(beginsWith)'"

                let filteredResults = result.filter(filterString)

                observer.send(value: Array(filteredResults))
                observer.sendCompleted()
            }
        }
    }

    fileprivate func readEntity(key: KEY) -> SignalProducer<VALUE.REALM_ENTITY, AppStoreError > {
        return SignalProducer { [weak self] observer, disposable in
            self?.async { [weak self] in
                guard let self = self,
                    let realm = self.rwRealm else {
                        observer.send(error: .failure(reason: "failed to get realm"))
                        return
                }

                guard let result = realm.object(ofType: VALUE.REALM_ENTITY.self, forPrimaryKey: key) else {
                    observer.send(error: .failure(reason: "failed to get realm object with key : \(key)"))
                    return
                }

                observer.send(value: result)
                observer.sendCompleted()
            }
        }
    }

    fileprivate func readAllEntity() -> SignalProducer<[VALUE.REALM_ENTITY], AppStoreError> {
        return SignalProducer { [weak self] observer, disposable in
            self?.async {
                guard let self = self,
                    let realm = self.rwRealm else {
                        observer.send(error: .failure(reason: "failed to get realm"))
                        return
                }

                let result = realm.objects(VALUE.REALM_ENTITY.self)
                observer.send(value: Array(result))
                observer.sendCompleted()
            }
        }
    }
}

extension CommonRealmDAO {
    func async(_ block: @escaping ()throws -> Void) {
        thread.enqueue(block: {
            try autoreleasepool {
                try block()
            }
        })
    }

    func pause() {
        _thread?.pause()
    }

    func resume() {
        _thread?.resume()
    }

    func stop() {
        _thread?.cancel()
        _thread = nil
    }
}
