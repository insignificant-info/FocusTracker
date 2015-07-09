//
//  Events.swift
//  
//
//  Created by Paul Brenner on 7/9/15.
//
//

import Foundation
import CoreData

@objc(Events)
class Events: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

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
