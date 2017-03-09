//
//  Photo+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Joao Anjos on 08/03/17.
//  Copyright © 2017 Joao Anjos. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var image: NSData?
    @NSManaged public var url: String?
    @NSManaged public var pin: Pin?

}
