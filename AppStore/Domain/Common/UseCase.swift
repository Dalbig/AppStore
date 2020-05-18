//
//  Usecase.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/17.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol UseCase: AnyObject {
    associatedtype Result
    func execute() -> SignalProducer<Result, AppStoreError>
}

protocol UseCaseWithParam: AnyObject {
    associatedtype Param
    associatedtype Result
    
    func execute(param: Param) -> SignalProducer<Result, AppStoreError>
}
