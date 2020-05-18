//
//  UseCaseTests.swift
//  AppStoreTests
//
//  Created by Yulmong on 2020/05/18.
//  Copyright © 2020 yulmong. All rights reserved.
//

import XCTest
import ReactiveSwift
@testable import AppStore

class UseCaseTests: XCTestCase {
    private let disposables = CompositeDisposable()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Context.initialize(.prod)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        disposables.dispose()
        Context.destroy()
    }

    func testSearchUseCase() {
        let expectation = self.expectation(description: "testSearchUseCase")
        let useCase: SearchAppUseCase = Context.resolve()

        disposables += useCase.execute(param: "카카오뱅크")
            .startWithResult { result in
                expectation.fulfill()
                switch result {
                case .success(let data):
                    XCTAssert(!data.isEmpty, "empty data")
                case .failure(let error):
                    XCTAssert(false, "failed : \(error.description)")
                }
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
