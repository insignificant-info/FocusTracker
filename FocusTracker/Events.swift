//
//  Events.swift
//  MyLog
//
//  Created by Paul Brenner on 6/10/15.
//  Copyright (c) 2015 Insignificant.Info. All rights reserved.
//

import Foundation
import CoreData

class Events: NSManagedObject {

    @NSManaged var controlVariable: Bool
    @NSManaged var eventType: String
    @NSManaged var focusEvent: NSDate
    @NSManaged var motivationScaleValue: Int
    @NSManaged var stanfordSleepinessValue: Int
  

    
    class func createInManagedObjectContext(moc: NSManagedObjectContext,
        controlVariable: Bool,
        eventType: String,
        focusEvent: NSDate,
        motivationScaleValue: Int,
        stanfordSleepinessValue: Int) -> Events {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Events", inManagedObjectContext: moc) as! Events
            newItem.controlVariable = controlVariable
            newItem.eventType = eventType
            newItem.focusEvent = focusEvent
            newItem.motivationScaleValue = motivationScaleValue
            newItem.stanfordSleepinessValue = stanfordSleepinessValue
        return newItem
    }
    
}
