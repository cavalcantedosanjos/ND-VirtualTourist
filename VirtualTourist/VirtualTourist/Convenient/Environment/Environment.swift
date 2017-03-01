//
//  Environment.swift
//  VirtualTourist
//
//  Created by Joao Anjos on 01/03/17.
//  Copyright © 2017 Joao Anjos. All rights reserved.
//

import UIKit

class Environment: NSObject {
    
    // MARK: Shared Instance
    class func sharedInstance() -> Environment {
        struct Singleton {
            static var sharedInstance = Environment()
        }
        return Singleton.sharedInstance
    }

}
