//
//  OptionsViewController.swift
//  Focus Tracker
//
//  Created by Paul Brenner on 6/10/15.
//  Copyright (c) 2015 Insignificant.Info. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var pickerValue: UIPickerView!
    @IBOutlet weak var sleepinessScaleNumeric: UILabel!
    @IBOutlet weak var motivationScaleNumeric: UILabel!
  
    struct ScaleValues {
    
    var sleepiness : Int
    var motivation : Int
    
    }
    
    struct MainControllerHiddenStates {
        var start : Bool
        var lostFocus : Bool
        var stop : Bool
        var pause : Bool
    }
    
    
    var mainControllerHiddenStates = MainControllerHiddenStates(start: true, lostFocus: false, stop: false, pause: false)
    
    var scaleValues = ScaleValues(sleepiness: 4, motivation: 4)
    let sleepinessScaleDefinitions = [
        "Feeling active, vital, alert, or wide awake",
        "Functioning at high levels, but not at peak; able to concentrate",
        "Awake, but relaxed; responsive but not fully alert",
        "Somewhat foggy, let down",
        "Foggy; losing interest in remaining awake; slowed down",
        "Sleepy, woozy, fighting sleep; prefer to lie down",
        "No longer fighting sleep, sleep onset soon; having dream-like thoughts"]
    
    
    let sleepinessScaleAbbreviations = [
        "Wide awake",
        "High-level",
        "Awake; relaxed",
        "Somewhat foggy",
        "Foggy; slow",
        "Sleepy, woozy",
        "Dream-like"]
    
    let motivationScaleAbbreviations = [
        "Compulsive",
        "Escape",
        "Enjoyable",
        "Fine fine",
        "Vegetables",
        "Painful",
        "Agony"]
    
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return sleepinessScaleAbbreviations.count
        } else {
            return motivationScaleAbbreviations.count
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return sleepinessScaleAbbreviations[row]
        } else {
            return motivationScaleAbbreviations[row]
        }
        
    }
    
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            sleepinessScaleNumeric.text = "SSS \(row + 1)"
            scaleValues.sleepiness = row + 1
        } else {
            motivationScaleNumeric.text = "IMS \(row + 1)"
            scaleValues.motivation = row + 1
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // initiatilize scale scrollers and their labels

        pickerValue.selectRow(scaleValues.sleepiness - 1, inComponent: 0, animated: false)
        pickerValue.selectRow(scaleValues.motivation - 1, inComponent: 1, animated: false)

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "returnSegue") {
            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
            let scaleSets = segue.destinationViewController as! ViewController;
            scaleSets.toPassSleep = scaleValues.sleepiness
            scaleSets.toPassMotivation = scaleValues.motivation
            
            print("return segue \(mainControllerHiddenStates.start)")
            
            let hiddenButtonStates = segue.destinationViewController as! ViewController;
            hiddenButtonStates.hiddenStates.start = mainControllerHiddenStates.start
            hiddenButtonStates.hiddenStates.lostFocus = mainControllerHiddenStates.lostFocus
            hiddenButtonStates.hiddenStates.stop = mainControllerHiddenStates.stop
            hiddenButtonStates.hiddenStates.pause = mainControllerHiddenStates.pause

            
       }
    }

}
