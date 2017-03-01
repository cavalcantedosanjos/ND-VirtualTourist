//
//  ErrorResponse.swift
//  VirtualTourist
//
//  Created by Joao Anjos on 01/03/17.
//  Copyright © 2017 Joao Anjos. All rights reserved.
//

import UIKit

struct ErrorResponse {
    
    var error: String?
    var code: String?
    
    init(dictionary: [String : AnyObject]) {
        self.error = dictionary["error"] as? String ?? ""
        self.code = dictionary["code"] as? String ?? ""
    }
    
    init(code: String, error: String) {
        self.code = code
        self.error = error
    }
}
