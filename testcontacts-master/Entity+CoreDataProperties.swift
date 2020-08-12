//
//  Entity+CoreDataProperties.swift
//  TestContacts
//
//  Created by Dave on 11/8/18.
//  Copyright © 2020 DaKar. All rights reserved.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var name: String?
    @NSManaged public var city: String?
    @NSManaged public var telephone: String? 
    @NSManaged public var lastName: String?
    @NSManaged public var email: String? 
    

}
