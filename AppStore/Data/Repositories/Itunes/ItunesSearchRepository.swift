//
//  ItunesSearchRepositories.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/17.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation
import ReactiveSwift

public typealias JsonDictionary = [String: Any]

class ItunesSearchRepository: SearchRepository {
    enum HttpStatusCode: Int {
        case ok = 200
        case notModified = 304
        case unAuthorized = 401
        case unknown
    }
    private let itunesUrl = "https://itunes.apple.com/search"
    private lazy var session: URLSession = URLSession(configuration: .default)
    private lazy var requestQueue: OperationQueue = {
        let q = OperationQueue()
        q.name = "ItunesRequestQueue"
        q.maxConcurrentOperationCount = 4
        return q
    }()

    init() {

    }

    deinit {
        requestQueue.isSuspended = true
        requestQueue.cancelAllOperations()
        session.invalidateAndCancel()
    }

    func search(term: String, limit: Int) -> SignalProducer<[AppContent], AppStoreError> {
        return SignalProducer { [weak self] observer, disposable in
            self?.requestQueue.addOperation {
                guard let self = self,
                    let request = self.getURLRequest(term: term, limit: limit) else {
                        observer.send(error: .failure(reason: "failed to get request"))
                        return
                }

                self.sendRequest(request: request) { apps, error in
                    if let error = error {
                        observer.send(error: error)
                    }

                    observer.send(value: apps)
                    observer.sendCompleted()
                }
            }
        }
    }

    private func getURLRequest(term: String, limit: Int) -> URLRequest? {
        guard let baseUrl = URL(string: itunesUrl) else {
            return nil
        }

        var request = URLRequest(url: baseUrl)
        request.timeoutInterval = 10

        var url = request.url

        let country = Locale.current.regionCode ?? "KR"
        let lang = country == "KR" ? "ko_kr" : "en_us"

        print(" lang : \(lang)")

        var urlComponents = URLComponents()

        urlComponents.queryItems = [
            URLQueryItem(name: "entity", value: "software"),
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "country", value: country),
            URLQueryItem(name: "lang", value: "\(lang)"),
            URLQueryItem(name: "limit", value: "\(limit)") /// 1 to 200
        ]

        url = urlComponents.url(relativeTo: url)
        request.url = url
        
        print(" url : \(url?.absoluteString)")

        return request
    }

    private func sendRequest(request: URLRequest, completion: @escaping ([AppContent], AppStoreError?) -> ()) {
        let task = session.dataTask(with: request) { resData, response, error in
            guard let code = (response as? HTTPURLResponse)?.statusCode else { return }

            let statusCode = HttpStatusCode(rawValue: code) ?? .unknown

            switch statusCode {
            case .ok:
                guard error == nil,
                    let data = resData,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JsonDictionary,
                    let results = json["results"] as? [JsonDictionary] else {
                        completion([], .failure(reason: "failed to make json object"))
                        return
                }

                let apps = results.map { AppContent(dict: $0) }
                completion(apps, nil)
            default:
                completion([], .network(code: "\(code)"))
            }
        }
        task.resume()
    }
}
