//
//  Context.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/18.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation

class Context {
    private static var soleInstance: ApplicationContextInterface?

    static private func getInstance() -> ApplicationContextInterface {
        guard let soleInstance = self.soleInstance else {
            fatalError("MledContext is not initialized")
        }

        return soleInstance
    }

    static func initialize(_ source: ContextType = .prod) {
        soleInstance = source.initialize()
    }

    static func destroy() {
        soleInstance?.destroy()
        soleInstance = nil
    }

    static func getObject<T>(key: String) -> T {
        return getInstance().resolve(key: key)
    }

    static func resolve<T>() -> T {
        return getInstance().resolve()
    }
}

enum ContextType {
    case prod
    case test

    func initialize() -> ApplicationContextInterface {
        switch self {
        case .prod:
            return ProdContext()
        case .test:
            return TestContext()
        }
    }
}
