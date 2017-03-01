//
//  FlickrService.swift
//  VirtualTourist
//
//  Created by Joao Anjos on 01/03/17.
//  Copyright © 2017 Joao Anjos. All rights reserved.
//

import UIKit

class FlickrService: NSObject {
   
    // MARK: Shared Instance
    class func sharedInstance() -> FlickrService {
        struct Singleton {
            static var sharedInstance = FlickrService()
        }
        return Singleton.sharedInstance
    }
    
    let key = "9912d4b07555336cb7b4335b4805d84e"
    let baseUrl = "https://api.flickr.com/services/rest/"

    enum Methods: String {
        case photoInfo = "flickr.photos.getInfo"
        case photosByLocation = "flickr.photos.getRecent"
    }
    
    // MARK: - Helpers
    
    func getFlickrUrlString(forMethod method: Methods) -> String {
        return (baseUrl + "?method=\(method.rawValue)&api_key=\(key)&format=json&nojsoncallback=1")
    }
    
    // MARK: - Service
    
    func getPhotosByLocation(latitude: Double, longitude: Double, onCompleted completed: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let url = getFlickrUrlString(forMethod: .photosByLocation) + "&lat=\(latitude)&lon=\(longitude)&extras=url_m"
        
        let request = NSMutableURLRequest()
        request.httpMethod = "GET"
        request.url = URL(string: url)!
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            completed(data, response, error)
        }
        
        task.resume()
    }
    
    func downloadPhoto(photoUrl: String, onCompleted completed: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let url = NSURL(string: photoUrl)
        let request = URLRequest(url: url! as URL)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request){ data, response, error in
            completed(data, response, error)
        }
        task.resume()
    }
}
