//
//  ResultsTableViewController.swift
//  Focus Tracker
//
//  Created by Paul Brenner on 6/12/15.
//  Copyright (c) 2015 Insignificant.Info. All rights reserved.
//

import UIKit
import CoreData

class ResultsTableViewController: UIViewController, UITableViewDataSource {

    // Create an empty array of LogItem's
    var events = [Events]()
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    

    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var logTableView: UITableView!
    
    
    @IBOutlet weak var backToResultsButton: UIButton!
    
    
//    var logTableView = UITableView(frame: CGRectZero, style: .Plain)
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // How many rows are there in this section?
        // There's only 1 section, and it has a number of rows
        // equal to the number of logItems, so return the count
        return events.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("LogCell") as UITableViewCell!
        
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "LogCell")
        
        // Get the LogItem for this index
        let eventItem = events[indexPath.row]
        
        // Set the title of the cell to be the title of the logItem
//        println(events[indexPath.row])
        
        cell.textLabel?.text = eventItem.eventType
        
        let dateItem = eventItem.focusEvent
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm" //format style
        let dateString = dateFormatter.stringFromDate(dateItem)
        
        cell.detailTextLabel?.text = dateString

        return cell
    }
    
    func fetchLog() {
        let fetchRequest = NSFetchRequest(entityName: "Events")
        
        // Create a sort descriptor object that sorts on the "title"
        // property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: "focusEvent", ascending: true)
        
        // Set the list of sort descriptors in the fetch request,
        // so it includes the sort descriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Events]
            events = fetchResults!
        } catch _ {
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete ) {
            // Find the LogItem object the user is trying to delete
            let logItemToDelete = events[indexPath.row]
            
            // Delete it from the managedObjectContext
            managedObjectContext.deleteObject(logItemToDelete)
            
            // Refresh the table view to indicate that it's deleted
            self.fetchLog()
            
            // Tell the table view to animate out that row
            logTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            save()
        }
    }
   
    let addItemAlertViewTag = 0
    let addItemTextAlertViewTag = 1
    func addNewItem() {
        
        let titlePrompt = UIAlertController(title: "Enter event type",
            message: "Enter Start, Stop, or Lost Focus",
            preferredStyle: .Alert)
        
        var titleTextField: UITextField?
        titlePrompt.addTextFieldWithConfigurationHandler {
            (textField) -> Void in
            titleTextField = textField
            textField.placeholder = "eventType"
        }
        
        titlePrompt.addAction(UIAlertAction(title: "Ok",
            style: .Default,
            handler: { (action) -> Void in
                if let textField = titleTextField {
                    self.saveNewItem(textField.text!)
                }
        }))
        
        self.presentViewController(titlePrompt,
            animated: true,
            completion: nil)
    }

    func saveNewItem(typeItem : String) {
        // Create the new  log item
        let date = NSDate()
        let newEventItem = Events.createInManagedObjectContext(self.managedObjectContext, controlVariable: false, eventType: typeItem, focusEvent: date, motivationScaleValue: 3, stanfordSleepinessValue: 3)
        
        // Update the array containing the table view row data
        self.fetchLog()
        
        // Animate in the new row
        // Use Swift's find() function to figure out the index of the newEvent
        // after it's been added and sorted in our logItems array
        if let newItemIndex = events.indexOf(newEventItem) {
            // Create an NSIndexPath from the newItemIndex
            let newEventItemIndexPath = NSIndexPath(forRow: newItemIndex, inSection: 0)
            // Animate in the insertion of this row
            logTableView.insertRowsAtIndexPaths([ newEventItemIndexPath ], withRowAnimation: .Automatic)
            save()
        }
    }
    

    
    func save () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Events", inManagedObjectContext: self.managedObjectContext!) as! Events
//        
//        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
//        let date = dateFormatter.dateFromString("2015-06-16 01:00:58 +0000")
//        
//        newItem.controlVariable = false
//        newItem.eventType = "Start"
//        newItem.focusEvent = date!
//        newItem.motivationScaleValue = 3
//        newItem.stanfordSleepinessValue = 4
        
        // Use optional binding to confirm the managedObjectContext
//        let moc = self.managedObjectContext
        

            
            // Now that the view loaded, we have a frame for the view, which will be (0,0,screen width, screen height)
            // This is a good size for the table view as well, so let's use that
            // The only adjust we'll make is to move it down by 20 pixels, and reduce the size by 20 pixels
            // in order to account for the status bar
            
            // Store the full frame in a temporary variable
//            var viewFrame = self.view.frame
            
            // Adjust it down by 20 points
//            viewFrame.origin.y += 50
            
            // Add in the "+" button at the bottom
            
//           let addButton = UIButton(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 44, UIScreen.mainScreen().bounds.size.width, 44))
//            addButton.setTitle("+", forState: .Normal)
//            addButton.backgroundColor = UIColor(red: 0.5, green: 0.9, blue: 0.5, alpha: 1.0)
            
            
            
            // self.view.addSubview(addButton)
            
            // Reduce the total height by 20 points for the status bar, and 44 points for the bottom button
            //  viewFrame.size.height -= (50 + addButton.frame.size.height)
            
            // Set the logTableview's frame to equal our temporary variable with the full size of the view
            // adjusted to account for the status bar height
            // logTableView.frame = viewFrame
            
            // Add the table view to this view controller's view
            //self.view.addSubview(logTableView)
            
            
            
            // This tells the table view that it should get it's data from this class, ViewController
            //logTableView.dataSource = self
            
            // Here, we tell the table view that we intend to use a cell we're going to call "LogCell"
            // This will be associated with the standard UITableViewCell class for now
            
            logTableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "LogCell")
            addButton.addTarget(self, action: "addNewItem", forControlEvents: .TouchUpInside)
        
        
        fetchLog()
    }
    

   


        // Do any additional setup after loading the view.
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
