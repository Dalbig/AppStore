//
//  CommonApplicationContext.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/18.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation

protocol ApplicationContextInterface {
    func resolve<T>() -> T
    func resolve<T>(key: String) -> T
    func destroy()
}

protocol CommonApplicationContextInterface: ApplicationContextInterface {
    func configure()
    func register<T>(_ assemble: @escaping () -> T)
    func register<T>(key: String, _ assemble: @escaping () -> T)
    func registerSingleton<T>(_ assemble: @escaping () -> T)
    func registerLazySingleton<T>(_ assemble: @escaping () -> T)
    func registerSingleton<T>(key: String, _ assemble: @escaping () -> T)
    func registerLazySingleton<T>(key: String, _ assemble: @escaping () -> T)
}

class CommonApplicationContext: CommonApplicationContextInterface {
    private(set) var factory = Assembler()
    private(set) var singletonMap = [String: Any]()
    private(set) var candidateSingletonList = Set<String>()
    init() {
        configure()
    }

    deinit {
        //CLLogDebug(.UG, "CommonApplicationContext.deinit")
    }
    
    func destroy() {
        singletonMap.removeAll()
        factory.removeAll()
    }

    func resolve<T>() -> T {
        let key = String(describing: T.self)
        if candidateSingletonList.contains(key) {
            candidateSingletonList.remove(key)
            singletonMap[key] = factory.resolve() as T
        }
        guard let object = singletonMap[key] as? T else {
            return factory.resolve() as T
        }
        return object
    }

    func resolve<T>(key: String) -> T {
        if candidateSingletonList.contains(key) {
            candidateSingletonList.remove(key)
            singletonMap[key] = factory.resolve(key: key)
        }
        guard let object = singletonMap[key] as? T else {
            return factory.resolve(key: key)
        }
        return object
    }

    func configure() {

    }

    func register<T>(_ assemble: @escaping () -> T) {
        factory.register(assemble)
    }

    func register<T>(key: String, _ assemble: @escaping () -> T) {
        factory.register(key: key, assemble)
    }

    func registerSingleton<T>(_ assemble: @escaping () -> T) {
        self.register(assemble)
        let key = String(describing: T.self)
        singletonMap[key] = factory.resolve(key: key) as T
    }
    
    func registerLazySingleton<T>(_ assemble: @escaping () -> T) {
        self.register(assemble)
        let key = String(describing: T.self)
        candidateSingletonList.insert(key)
    }

    func registerSingleton<T>(key: String, _ assemble: @escaping () -> T) {
        self.register(key: key, assemble)
        singletonMap[key] = factory.resolve(key: key) as T
    }
    
    func registerLazySingleton<T>(key: String, _ assemble: @escaping () -> T) {
        self.register(key: key, assemble)
        candidateSingletonList.insert(key)
    }
}
