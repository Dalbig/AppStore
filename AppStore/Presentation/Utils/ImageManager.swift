//
//  ImageManager.swift
//  AppStore
//
//  Created by Yulmong on 2020/05/21.
//  Copyright © 2020 yulmong. All rights reserved.
//

import Foundation
import UIKit

class ImageManasger {
    class func downloadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        guard let catPictureURL = URL(string: url) else {
            completion(nil)
            return
        }

        // Creating a session object with the default configuration.
        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
        let session = URLSession(configuration: .default)

        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
                completion(nil)
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        completion(image)
                        // Do something with your image.
                    } else {
                        print("Couldn't get image: Image is nil")
                        completion(nil)
                    }
                } else {
                    print("Couldn't get response code for some reason")
                    completion(nil)
                }
            }
        }

        downloadPicTask.resume()
    }
}
