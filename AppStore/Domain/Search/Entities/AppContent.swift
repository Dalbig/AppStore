//
//  App.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/17.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation

struct AppContent {
    var screenshotUrls: [String]
    var supportedDevices: [String]
    var artworkUrl512: String
    var artistViewUrl: String
    var artworkUrl60: String
    var artworkUrl100: String
    var kind: String
    var trackViewUrl: String
    var trackContentRating: String // +4
    var trackCensoredName: String
    var fileSizeBytes: String
    var sellerUrl: String
    var contentAdvisoryRating: String //4+
    var averageUserRatingForCurrentVersion: Double // 별점 double (3.618160000000000042774672692758031189441680908203125)
    var userRatingCountForCurrentVersion: Int
    var averageUserRating: String
    var trackId: String
    var trackName: String
    var releaseNotes: String
    var releaseDate: String
    var currentVersionReleaseDate: String
    var formattedPrice: String
    var primaryGenreName: String
    var sellerName: String
    var currency: String
    var version: String
    var wrapperType: String
    var artistId: String
    var artistName: String
    var genres: [String]
    var description: String
    var bundleId: String
    var userRatingCount: String

    init(dict: [String: Any]) {
        screenshotUrls = dict["screenshotUrls"] as? [String] ?? []
        supportedDevices = dict["supportedDevices"] as? [String] ?? []

        artworkUrl512 = dict["artworkUrl512"] as? String ?? ""
        artistViewUrl = dict["artistViewUrl"] as? String ?? ""
        artworkUrl60 = dict["artworkUrl60"] as? String ?? ""
        artworkUrl100 = dict["artworkUrl100"] as? String ?? ""
        kind = dict["kind"] as? String ?? ""
        trackViewUrl = dict["trackViewUrl"] as? String ?? ""
        trackContentRating = dict["trackContentRating"] as? String ?? ""
        trackCensoredName = dict["trackCensoredName"] as? String ?? ""
        fileSizeBytes = dict["fileSizeBytes"]as? String ?? ""
        sellerUrl = dict["sellerUrl"]as? String ?? ""
        contentAdvisoryRating = dict["contentAdvisoryRating"]as? String ?? ""
        averageUserRatingForCurrentVersion = dict["averageUserRatingForCurrentVersion"]as? Double ?? 0
        userRatingCountForCurrentVersion = dict["userRatingCountForCurrentVersion"]as? Int ?? 0
        averageUserRating = dict["averageUserRating"]as? String ?? ""
        sellerUrl = dict["sellerUrl"] as? String ?? ""
        averageUserRating = dict["averageUserRating"] as? String ?? ""
        trackId = dict["trackId"] as? String ?? ""
        trackName = dict["trackName"] as? String ?? ""
        releaseNotes = dict["releaseNotes"] as? String ?? ""
        releaseDate = dict["releaseDate"] as? String ?? ""
        currentVersionReleaseDate = dict["currentVersionReleaseDate"] as? String ?? ""
        formattedPrice = dict["formattedPrice"] as? String ?? ""
        primaryGenreName = dict["primaryGenreName"] as? String ?? ""
        sellerName = dict["sellerName"] as? String ?? ""
        currency = dict["currency"] as? String ?? ""
        version = dict["version"] as? String ?? ""
        wrapperType = dict["wrapperType"] as? String ?? ""
        artistId = dict["artistId"] as? String ?? ""

        artistName = dict["artistName"] as? String ?? ""
        genres = dict["genres"] as? [String] ?? []
        description = dict["description"] as? String ?? ""
        bundleId = dict["bundleId"] as? String ?? ""
        userRatingCount = dict["userRatingCount"] as? String ?? ""
    }
}
