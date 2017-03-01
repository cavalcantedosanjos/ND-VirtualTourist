//
//  JSON.swift
//  VirtualTourist
//
//  Created by Joao Anjos on 01/03/17.
//  Copyright © 2017 Joao Anjos. All rights reserved.
//

import UIKit

class JSON: NSObject {
    
    class func deserialize(data: Data) -> AnyObject{
        var parsedResult: AnyObject?
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            return parsedResult!
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            print(userInfo)
        }
        
        return "" as AnyObject
    }
}
