//
//  Error.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/17.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation

enum AppStoreError: Error {
    case failure(reason: String)
    case network(code: String)

    var description: String {
        switch self {
        case .failure(let reason):
            return reason
        case .network(let code):
            return code
        }
    }
}
