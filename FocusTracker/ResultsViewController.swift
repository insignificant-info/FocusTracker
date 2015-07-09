//
//  ResultsViewController.swift
//  Focus Tracker
//
//  Created by Paul Brenner on 6/12/15.
//  Copyright (c) 2015 Insignificant.Info. All rights reserved.
//

import UIKit
import CoreData
import SwiftCharts


@IBDesignable



class ResultsViewController: UIViewController{

    //CHARTING
    
    private var chart: Chart?
    
    private enum MyExampleModelDataType {
        case Type0, Type1, Type2, Type3
    }
    
    private enum Shape {
        case Triangle, Square, Circle, Cross
    }
    
    private func toLayers(models: [(x: CGFloat, y: CGFloat, type: MyExampleModelDataType)], layerSpecifications: [MyExampleModelDataType : (shape: Shape, color: UIColor)], xAxis: ChartAxisLayer, yAxis: ChartAxisLayer, chartInnerFrame: CGRect) -> [ChartLayer] {
        
        // group chartpoints by type
        let groupedChartPoints: Dictionary<MyExampleModelDataType, [ChartPoint]> = models.reduce(Dictionary<MyExampleModelDataType, [ChartPoint]>()) {(var dict, model) in
            let chartPoint = ChartPoint(x: ChartAxisValueFloat(model.x), y: ChartAxisValueFloat(model.y))
            if dict[model.type] != nil {
                dict[model.type]!.append(chartPoint)
                
            } else {
                dict[model.type] = [chartPoint]
            }
            return dict
        }
        
        // create layer for each group
        let dim: CGFloat = Env.iPad ? 14 : 7
        let size = CGSizeMake(dim, dim)
        let layers: [ChartLayer] = groupedChartPoints.map {(type, chartPoints) in
            let layerSpecification = layerSpecifications[type]!
            switch layerSpecification.shape {
            case .Triangle:
                return ChartPointsScatterTrianglesLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: chartInnerFrame, chartPoints: chartPoints, itemSize: size, itemFillColor: layerSpecification.color)
            case .Square:
                return ChartPointsScatterSquaresLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: chartInnerFrame, chartPoints: chartPoints, itemSize: size, itemFillColor: layerSpecification.color)
            case .Circle:
                return ChartPointsScatterCirclesLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: chartInnerFrame, chartPoints: chartPoints, itemSize: size, itemFillColor: layerSpecification.color)
            case .Cross:
                return ChartPointsScatterCrossesLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: chartInnerFrame, chartPoints: chartPoints, itemSize: size, itemFillColor: layerSpecification.color)
            }
        }
        
        return layers
    }
    
    // END CHARTING
    @IBOutlet weak var focusDurationTime: UIView?

    // Create an empty array of LogItem's
    var events = [Events]()
    
    // Retreive the managedObjectContext from AppDelegate
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    func fetchLog() {
        let fetchRequest = NSFetchRequest(entityName: "Events")
        fetchRequest.returnsObjectsAsFaults = false
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
    
    func dateBetweenTwoDates(newdate: NSDate, olddate: NSDate) -> NSDate
    {

        let halfinterval: NSTimeInterval = -(newdate.timeIntervalSinceDate(olddate)/2)
        
        return newdate.dateByAddingTimeInterval(halfinterval)
    }
    
    
//    func SetChart(x1Values: [Double], y1Values: [Double], x2Values: [Double], y2Values: [Double], chartVariable: ScatterChartView) {
//        var dataSeries1: [ChartDataEntry] = []
//        var dataSeries2: [ChartDataEntry] = []
//        
//        for i in 0..<x1Values.count {
//            let dataEntry1 = ChartDataEntry(value: y1Values[i], xIndex: i)
//            dataSeries1.append(dataEntry1)
//        }
//        
//        for i in 0..<x2Values.count {
//            let dataEntry2 = ChartDataEntry(value: y2Values[i], xIndex: i)
//            dataSeries2.append(dataEntry2)
//        }
//        
//        let chartDataSet1 = ScatterChartDataSet(yVals: dataSeries1, label: "Control")
//        chartDataSet1.scatterShape = .Circle
//        chartDataSet1.scatterShapeSize = 9
//        chartDataSet1.setColor(UIColor.blueColor())
//        
//        let chartDataSet2 = ScatterChartDataSet(yVals: dataSeries2, label: "Experiment")
//        chartDataSet2.scatterShape = .Circle
//        chartDataSet2.scatterShapeSize = 9
//        chartDataSet2.setColor(UIColor.redColor())
//        
//        
//        var xValuesCombined = x1Values //[x1Values,x2Values]
//        xValuesCombined += x2Values
//        
//        let chartDataSetsCombined = [chartDataSet1,chartDataSet2]
//        
//        let chartData = ScatterChartData(xVals: xValuesCombined, dataSets: chartDataSetsCombined)
//        
//        chartVariable.data = chartData
//        chartVariable.xAxis.labelPosition = .Bottom
//        chartVariable.xAxis.isEnabled
//        chartVariable.rightAxis.isEnabled
//        
//        var makeSize =  CGSizeMake(self.view.frame.width * 0.5, self.view.frame.height * 0.2)
//        chartVariable.sizeThatFits(makeSize)
//        
//        
//        chartVariable.descriptionText = ""
//        chartVariable.gridBackgroundColor = UIColor.whiteColor()
//        
//        
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("here")

        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "Events")
  
        
        do {
        let fetchResult = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Events]
            if fetchResult.count == 0 {
                print("No events found")
                
                
                let newItem = NSEntityDescription.insertNewObjectForEntityForName("Events", inManagedObjectContext: self.managedObjectContext) as! Events
                
                
                newItem.controlVariable = false
                newItem.eventType = "Initialize"
                newItem.focusEvent = NSDate()
                newItem.motivationScaleValue = 3
                newItem.stanfordSleepinessValue = 4
                
            }
        } catch _ {
            }
        
        
        
        
        
        
        fetchLog()

        
        var deltaBetweenFocusEvents : [Int] = [] // the number of minutes between events
        var hourBrokenIntoMinuteChunks : [Int] = []  // break the hour up into chunks of minutes between focus events
        var dateAssociatedWithMinuteChunks : [NSDate] = [] // track the date for each of those chunks
        var focusPeriodMinuteValue : [Int] = [] // Weight each chunk by the length of the focus period
//        var focusPeriodMidPoint : [NSDate] = []  // plot each data point at the middle of the chunk (hour)
        var dateArrayForPlottingRaw : [NSDate] = [] // Focus event dates and midpoint dates in one array
        var focusValueArrayForPlottingRaw: [Int] = [] // Raw value of focus period
//        var dateArrayForPlottingHourAverages : [NSDate] = [] // Hour with focus events
//        var focusValueArrayForPlottingHourAverages: [Int] = [] //Focus Period value for the hour
        var controlVariableValueForMinuteChunks : [Bool] = [] // track the control variable for each chunk

        
        for (index, _) in events.enumerate() {
        
            // Currently I don't have any steps that I want to do when index == 0
            // I'm pretty sure continue just skipsthe first index
            let eventItem = events[index]
            
            if index == 0 {
                continue
            }
            
            
            let oldEventItem = events[index - 1]
            
            // I'm not counting any focus events that last 4+ hours, that is ridiculous
            if eventItem.focusEvent.minutesAfterDate(oldEventItem.focusEvent) >= 360 {
                continue
            }
            
            if  oldEventItem.eventType != "Stop" {
                // first create the delta
                deltaBetweenFocusEvents.append(eventItem.focusEvent.minutesAfterDate(oldEventItem.focusEvent))
                
                if focusValueArrayForPlottingRaw.last != nil {
                    focusValueArrayForPlottingRaw.append((deltaBetweenFocusEvents.last! + focusValueArrayForPlottingRaw.last!)/2)
                }
                // first append the midpoint between last event and current event, then append current event
                dateArrayForPlottingRaw.append(dateBetweenTwoDates(eventItem.focusEvent, olddate: oldEventItem.focusEvent))
                dateArrayForPlottingRaw.append(eventItem.focusEvent)
                focusValueArrayForPlottingRaw.append(deltaBetweenFocusEvents.last!)
                
                if (eventItem.focusEvent.hour() == oldEventItem.focusEvent.hour()) {
                    // if all of the time in the delta is contained within the hour
                    // then the chunk is equal to the delta
                    hourBrokenIntoMinuteChunks.append(deltaBetweenFocusEvents.last!)
                    dateAssociatedWithMinuteChunks.append(eventItem.focusEvent)
                    focusPeriodMinuteValue.append(deltaBetweenFocusEvents.last!)
                    controlVariableValueForMinuteChunks.append(eventItem.controlVariable)
                    
                } else if (eventItem.focusEvent.hour() - oldEventItem.focusEvent.hour() == 1)  {
                    // if the focus period started before the hour
                    // then the first chunk is equal to 60 - the minutes of the old event
                    // and the second chunk is equal to the number of minutess of the new event
                    hourBrokenIntoMinuteChunks.append((60 - oldEventItem.focusEvent.minute()))
                    dateAssociatedWithMinuteChunks.append(oldEventItem.focusEvent)
                    focusPeriodMinuteValue.append(deltaBetweenFocusEvents.last!)
                    controlVariableValueForMinuteChunks.append(oldEventItem.controlVariable)
                    hourBrokenIntoMinuteChunks.append((eventItem.focusEvent.minute()))
                    dateAssociatedWithMinuteChunks.append(eventItem.focusEvent)
                    focusPeriodMinuteValue.append(deltaBetweenFocusEvents.last!)
                    controlVariableValueForMinuteChunks.append(eventItem.controlVariable)
                } else {
                    
                    // if the focus period covers the entire hour
                    // then add chunks of 60 minutes to cover each hour in the focus period
                    // that is one high quality focus period, friend

                    var i = deltaBetweenFocusEvents.last!
                    var hourindex = 0
                    // first create a chunk from the portion of the 0th hour until the hour rolls over
                    hourBrokenIntoMinuteChunks.append((60 - oldEventItem.focusEvent.minute()))
                    dateAssociatedWithMinuteChunks.append(eventItem.focusEvent)
                    focusPeriodMinuteValue.append(deltaBetweenFocusEvents.last!)
                    controlVariableValueForMinuteChunks.append(oldEventItem.controlVariable)
                    
                    // subtract off the time in that chunk
                    i -= (60 - oldEventItem.focusEvent.minute())
                    
                    while i > 0 {
                        // increment the hour index at the start of the loop
                            ++hourindex
                      
                        
                        if i >= 60 {
                            hourBrokenIntoMinuteChunks.append(60)
                            dateAssociatedWithMinuteChunks.append(oldEventItem.focusEvent.dateByAddingHours(hourindex))
                            focusPeriodMinuteValue.append(deltaBetweenFocusEvents.last!)
                            controlVariableValueForMinuteChunks.append(oldEventItem.controlVariable)
                        } else {
                            hourBrokenIntoMinuteChunks.append(i)
                            dateAssociatedWithMinuteChunks.append(oldEventItem.focusEvent.dateByAddingHours(hourindex))
                            focusPeriodMinuteValue.append(deltaBetweenFocusEvents.last!)
                            controlVariableValueForMinuteChunks.append(oldEventItem.controlVariable)
                        }
                        
                        // reduce i by 60 minutes
                        i -= 60
                    }
                }
                print(eventItem.focusEvent)
                print("Day: \(eventItem.focusEvent.day())")
                print("Hour: \(eventItem.focusEvent.hour())")
                print("Minute: \(eventItem.focusEvent.minute())")
                print("Seconds: \(eventItem.focusEvent.seconds())")
                
            }
        }

//        var dataSeries1X : Array<Double> = []
//        var dataSeries1Y : Array<Double> = []
//        var dataSeries2X : Array<Double> = []
//        var dataSeries2Y : Array<Double> = []
        var consecutiveFocusPeriodValue : [Int] = []
        var testMinutesInHour = 0
        var hourOfPreviousElement = -1 //initialize with a value that can't be associated with an hour
        var labels: Array<Int> = []
        var labelsAsString: Array<String> = []
        var models: [(x: CGFloat, y: CGFloat, type: MyExampleModelDataType)] = []
        
        var xMin = 24
        var xMax = 0

        let tempHourBrokenIntoMinuteChunks = hourBrokenIntoMinuteChunks
        
        for (controlIndex) in 0...1 {
            //reset hourBrokenIntoMinuteChunks at the start of the loop
            hourBrokenIntoMinuteChunks = tempHourBrokenIntoMinuteChunks
            if controlIndex == 0 {
                // zero out hourBrokenIntoMinuteChunks for control in case 0 and for non control in case 1
                for (subIndex, _) in controlVariableValueForMinuteChunks.enumerate() {
                    if controlVariableValueForMinuteChunks[subIndex] == false { hourBrokenIntoMinuteChunks[subIndex] = 0 }
                }
            } else if controlIndex == 1 {
                for (subIndex, _) in controlVariableValueForMinuteChunks.enumerate(){
                    if controlVariableValueForMinuteChunks[subIndex] == true { hourBrokenIntoMinuteChunks[subIndex] = 0 }
                }
            }
            
            for (index, element) in dateAssociatedWithMinuteChunks.enumerate(){
               // run through every element and break focus periods into chunks that fit within each hour
                let hour = element.hour()
                
                if hourBrokenIntoMinuteChunks[index] < 1 {
                    // Don't count focus periods that are less than 1 minute
                    hourOfPreviousElement = hour
                    continue
                }
                
                if index == 0 {
                    //Just isolating the first index here to keep the if/else below simpler
                    let weightedFocusValue = focusPeriodMinuteValue[index] * hourBrokenIntoMinuteChunks[index]
                    consecutiveFocusPeriodValue.append(weightedFocusValue)
                    testMinutesInHour += hourBrokenIntoMinuteChunks[index]
                    hourOfPreviousElement = hour
                    continue
                }
                

                
                if hour == hourOfPreviousElement && index != (dateAssociatedWithMinuteChunks.count - 1){
                    let weightedFocusValue = focusPeriodMinuteValue[index] * hourBrokenIntoMinuteChunks[index]
                    consecutiveFocusPeriodValue.append(weightedFocusValue)
                    testMinutesInHour += hourBrokenIntoMinuteChunks[index]
                    
                } else {
                    // Case when switching to a new hour, first save the old data into the data series array
                    // x should just be the previous hour, y is a sum of the focus period values
                    // focus period values are weighted * hourBrokenIntoMinuteChunks
                    // the 1/testMinutesInHour is there in case there were some pauses in the hour this weights to the shorter time period in the hour
                    
                    if index == (dateAssociatedWithMinuteChunks.count - 1) {
                        //if this is the last data point in the set we don't want to ignore it, but still want to run the other clean up
                        let weightedFocusValue = focusPeriodMinuteValue[index] * hourBrokenIntoMinuteChunks[index]
                        consecutiveFocusPeriodValue.append(weightedFocusValue)
                        testMinutesInHour += hourBrokenIntoMinuteChunks[index]
                    }
                    
                    var yValue : Double = 0
                    if testMinutesInHour != 0 {yValue = Double(consecutiveFocusPeriodValue.reduce(0, combine: +)) * (1/Double(testMinutesInHour))}
                    
                    
                    
                    
                    //Break up the data into two serieses one for control, one for experiment
                    if controlIndex == 0 {
//                        dataSeries1X.append(Double(hourOfPreviousElement))
//                        dataSeries1Y.append(yValue)
                        models.append(x: CGFloat(hourOfPreviousElement),y: CGFloat(yValue),type: .Type1)
                       
                    } else {
//                        dataSeries2X.append(Double(hourOfPreviousElement))
//                        dataSeries2Y.append(yValue)
                        models.append(x: CGFloat(hourOfPreviousElement),y: CGFloat(yValue),type: .Type2)
                    }
                    
                    if index != (dateAssociatedWithMinuteChunks.count - 1) {
                    //Now clear the variables that were building up in the past hour
                    consecutiveFocusPeriodValue.removeAll(keepCapacity: false)
                    testMinutesInHour = 0
                    //And fill them with the new data point for this hour
                    consecutiveFocusPeriodValue.append(focusPeriodMinuteValue[index] * hourBrokenIntoMinuteChunks[index])
                    testMinutesInHour += hourBrokenIntoMinuteChunks[index]
                    }
                    
                    if xMin >= hourOfPreviousElement {
                        xMin = hourOfPreviousElement - 1
                    }
                    if xMax <= hourOfPreviousElement {
                        xMax = hourOfPreviousElement + 1
                    }
                    
                }
                
                
                hourOfPreviousElement = hour
                
            }
        
        }
        
        // llet series1 = ChartSeries([0, 6, 2, 8, 4, 7, 3, 10, 8])
        // series1.color = ChartColors.yellowColor()
        // series1.area = true
  
//        println(deltaBetweenFocusEvents)
//        println(hourBrokenIntoMinuteChunks)
//        println(dateAssociatedWithMinuteChunks)
//        println(focusPeriodMinuteValue)
    
        
//        SetChart(dataSeries1X, y1Values: dataSeries1Y, x2Values: dataSeries2X, y2Values: dataSeries2Y, chartVariable: focusDurationTime)
        
        
//        // MARK: CHARTING
        
                for i in xMin...xMax {
        
                    switch i {
                    case 0:
                        let hourAsString: String = "12"
                        labelsAsString.append(hourAsString)
                        labels.append(Int(12))
                    case 1...11:
                        let hourAsString: String = "\(i)"
                        labelsAsString.append(hourAsString)
                        labels.append(i)
                    case 12:
                        let hourAsString: String = "\(i)"
                        labelsAsString.append(hourAsString)
                        labels.append(i)
                    case 13...23:
                        let hourAsString: String = "\(i - 12)"
                        labelsAsString.append(hourAsString)
                        labels.append(i - 12)
                    default:
                        let hourAsString: String = "\(i)"
                        labelsAsString.append(hourAsString)
                        labels.append(i)
                    }
                }
        
//        for i in xMin...xMax {
//            
//            switch i {
//            case 0:
//                let hourAsString: String = "12"
//                labelsAsString.append(hourAsString)
//                labels.append(Float(i))
//            case 1...11:
//                let hourAsString: String = "\(i)"
//                labelsAsString.append(hourAsString)
//                labels.append(Float(i))
//            case 12:
//                let hourAsString: String = "\(i)"
//                labelsAsString.append(hourAsString)
//                labels.append(Float(i))
//            case 13...23:
//                let hourAsString: String = "\(i - 12)"
//                labelsAsString.append(hourAsString)
//                labels.append(Float(i))
//            default:
//                let hourAsString: String = "\(i)"
//                labelsAsString.append(hourAsString)
//                labels.append(Float(i))
//            }
//        }
        
        
        // map model data to chart points
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        
        
        let layerSpecifications: [MyExampleModelDataType : (shape: Shape, color: UIColor)] = [
            .Type0 : (.Triangle, UIColor.redColor()),
            .Type1 : (.Square, UIColor.blueColor()),
            .Type2 : (.Circle, UIColor.greenColor()),
            .Type3 : (.Cross, UIColor.blackColor())
        ]
        
        let xValues = labels.map {ChartAxisValueInt($0, labelSettings: labelSettings)}
        let yValues = Array(stride(from: 0, through: 300, by: 50)).map {ChartAxisValueInt($0, labelSettings: labelSettings)}
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings))
        
        let chartFrame = ExamplesDefaults.chartFrame(self.view.bounds)
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: ExamplesDefaults.chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
        let scatterLayers = self.toLayers(models, layerSpecifications: layerSpecifications, xAxis: xAxis, yAxis: yAxis, chartInnerFrame: innerFrame)
        
        let guidelinesLayerSettings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.blackColor(), linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: guidelinesLayerSettings)
        
        let chart = Chart(
            frame: chartFrame,
            layers: [
                xAxis,
                yAxis,
                guidelinesLayer
                ] + scatterLayers
        )
        
        self.view.addSubview(chart.view)
        self.chart = chart
        
//        // MARK: END CHARTING
        

        

        
    }
    
    
    
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
