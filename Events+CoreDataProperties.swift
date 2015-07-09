//
//  Events+CoreDataProperties.swift
//  
//
//  Created by Paul Brenner on 7/9/15.
//
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Events {

    @NSManaged var controlVariable: NSNumber?
    @NSManaged var eventType: String?
    @NSManaged var focusEvent: NSDate?
    @NSManaged var motivationScaleValue: NSNumber?
    @NSManaged var stanfordSleepinessValue: NSNumber?
    
    

}
