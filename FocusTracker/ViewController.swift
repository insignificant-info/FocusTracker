

import UIKit
import CoreData



class ViewController: UIViewController {
    
    
    @IBOutlet weak var controlVariable: UISwitch!
    @IBOutlet weak var lostFocusButtonOutlet: UIButton!
    @IBOutlet weak var startButtonOutlet: UIButton!
    @IBOutlet weak var stopButtonOutlet: UIButton!
    @IBOutlet weak var pauseButtonOutlet: UIButton!
    
    
    // create variables for sharing sleep and motivation state between views
    var toPassSleep : Int = 4
    var toPassMotivation : Int = 4
    
    
    struct HiddenStates {
        var start : Bool
        var lostFocus : Bool
        var stop : Bool
        var pause : Bool
    }
    
    var hiddenStates = HiddenStates(start: false, lostFocus: true, stop: true, pause: true)
    
    @IBAction func startButton () {
        
        startButtonOutlet.hidden = true
        lostFocusButtonOutlet.hidden = false
        stopButtonOutlet.hidden = false
        //        pauseButtonOutlet.hidden = false
        let appDel : AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let focusEvent = NSEntityDescription.insertNewObjectForEntityForName("Events", inManagedObjectContext: context) as NSManagedObject
        let Timestamp = NSDate()
        
        focusEvent.setValue(Timestamp, forKey: "focusEvent")
        focusEvent.setValue("Start", forKey: "eventType")
        
        
        
        focusEvent.setValue(toPassSleep, forKey: "stanfordSleepinessValue")
        focusEvent.setValue(toPassMotivation, forKey: "motivationScaleValue")
        focusEvent.setValue(controlVariable.on, forKey: "controlVariable")
        do {
            try context.save()
        } catch _ {
        }
        
        print(focusEvent)
        print("start object saved")
        
    }
    
    @IBAction func lostFocusButton(sender: AnyObject) {
        let appDel : AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let focusEvent = NSEntityDescription.insertNewObjectForEntityForName("Events", inManagedObjectContext: context) as NSManagedObject
        let Timestamp = NSDate()
        
        
        focusEvent.setValue(Timestamp, forKey: "focusEvent")
        focusEvent.setValue("Lost Focus", forKey: "eventType")
        
        
        focusEvent.setValue(toPassSleep, forKey: "stanfordSleepinessValue")
        focusEvent.setValue(toPassMotivation, forKey: "motivationScaleValue")
        focusEvent.setValue(controlVariable.on, forKey: "controlVariable")
        do {
            try context.save()
        } catch _ {
        }
        
        print(focusEvent)
        print("LF object saved")
        
    }
    
    @IBAction func stopButton(sender: AnyObject) {
        lostFocusButtonOutlet.hidden = true
        stopButtonOutlet.hidden = true
        startButtonOutlet.hidden = false
        //        pauseButtonOutlet.hidden = true
        
        let appDel : AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let focusEvent = NSEntityDescription.insertNewObjectForEntityForName("Events", inManagedObjectContext: context) as NSManagedObject
        let Timestamp = NSDate()
        focusEvent.setValue(Timestamp, forKey: "focusEvent")
        focusEvent.setValue("Stop", forKey: "eventType")
        
        focusEvent.setValue(toPassSleep, forKey: "stanfordSleepinessValue")
        focusEvent.setValue(toPassMotivation, forKey: "motivationScaleValue")
        focusEvent.setValue(controlVariable.on, forKey: "controlVariable")
        do {
            try context.save()
        } catch _ {
        }
        
        print(focusEvent)
        print("stop object saved")
        
        
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "optionsSegue") {
            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
            
            let hiddenStatesForTransition = segue.destinationViewController as! OptionsViewController
            
            hiddenStatesForTransition.mainControllerHiddenStates.start = startButtonOutlet.hidden
            hiddenStatesForTransition.mainControllerHiddenStates.lostFocus = lostFocusButtonOutlet.hidden
            hiddenStatesForTransition.mainControllerHiddenStates.stop = stopButtonOutlet.hidden
            hiddenStatesForTransition.mainControllerHiddenStates.pause = pauseButtonOutlet.hidden
            
            let scaleValues = segue.destinationViewController as! OptionsViewController;
            
            scaleValues.scaleValues.sleepiness = toPassSleep
            scaleValues.scaleValues.motivation = toPassMotivation
            
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButtonOutlet.hidden = hiddenStates.start
        lostFocusButtonOutlet.hidden = hiddenStates.lostFocus
        stopButtonOutlet.hidden = hiddenStates.stop
        pauseButtonOutlet.hidden = hiddenStates.pause
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

