//
//  MokItunesSearchRepository.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/17.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation
import ReactiveSwift

class MockItunesSearchRepository: SearchRepository {
    func search(term: String, limit: Int) -> SignalProducer<[AppContent], AppStoreError> {
        guard let dictArray = readJSONFromFile(fileName: "SearchResult") as? [[String: Any]] else {
            return SignalProducer(error: .failure(reason: "fail to get json"))
        }

        return SignalProducer(value: dictArray.map { AppContent(dict: $0) })
    }

    func readJSONFromFile(fileName: String) -> Any? {
        var json: [String: Any]?
        if let path = Bundle.main.path(forResource: fileName, ofType: "txt") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            } catch {
                // Handle error here
            }
        }
        return json?["results"]
    }
}
