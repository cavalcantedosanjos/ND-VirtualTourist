//
//  Map.swift
//  VirtualTourist
//
//  Created by Joao Anjos on 08/03/17.
//  Copyright © 2017 Joao Anjos. All rights reserved.
//

import UIKit

class Map: NSObject {
    
    static var latitude: Double {
        get {
            return UserDefaults.standard.double(forKey: "latitude")
        } set {
            UserDefaults.standard.set(newValue, forKey: "latitude")
        }
    }
    
    static var longitude: Double {
        get {
            return UserDefaults.standard.double(forKey: "longitude")
        } set {
            UserDefaults.standard.set(newValue, forKey: "longitude")
        }
    }
    
    static var latitudeDelta: Double {
        get {
            return UserDefaults.standard.double(forKey: "latitudeDelta")
        } set {
            UserDefaults.standard.set(newValue, forKey: "latitudeDelta")
        }
    }
    
    static var longitudeDelta: Double {
        get {
            return UserDefaults.standard.double(forKey: "longitudeDelta")
        } set {
            UserDefaults.standard.set(newValue, forKey: "longitudeDelta")
        }
    }

}
