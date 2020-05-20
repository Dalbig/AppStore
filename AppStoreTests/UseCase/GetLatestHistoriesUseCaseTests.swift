//
//  GetLatestHistoriesUseCaseTests.swift
//  AppStoreTests
//
//  Created by Yulmong on 2020/05/19.
//  Copyright © 2020 yulmong. All rights reserved.
//

import XCTest
import ReactiveSwift
@testable import AppStore

class GetLatestHistoriesUseCaseTests: XCTestCase {
    private let disposables = CompositeDisposable()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Context.initialize(.prod)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        let repository: HistoryRepository = Context.resolve()
        repository.deleteAllHistories()
        disposables.dispose()
        Context.destroy()
    }

    func testGetLatestHistories() {
        let expectation = self.expectation(description: "testSearchUseCase")
        let useCase: GetLatestHistoriesUseCase = Context.resolve()
        let repository: HistoryRepository = Context.resolve()

        repository.AddHistories(histories: getDummyHistories())

        disposables += useCase.execute()
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

    private func getDummyHistories() -> [History] {
        return [
            History(id: "카프리선", term: "카카오톡", updatedDate: Date().timeIntervalSince1970),
            History(id: "카카오", term: "카카오톡", updatedDate: Date().timeIntervalSince1970),
            History(id: "카카오뱅크", term: "카카오톡", updatedDate: Date().timeIntervalSince1970),
            History(id: "카카오ㅇㅇ", term: "카카오톡", updatedDate: Date().timeIntervalSince1970),
            History(id: "카카오 ㅍㅊ", term: "카카오톡", updatedDate: Date().timeIntervalSince1970),
            History(id: "카카오ㄷㄱ", term: "카카오톡", updatedDate: Date().timeIntervalSince1970),
            History(id: "카카오치즈", term: "카카오톡", updatedDate: Date().timeIntervalSince1970),
            History(id: "카카옽", term: "카카오톡", updatedDate: Date().timeIntervalSince1970),
        ]
    }
}
