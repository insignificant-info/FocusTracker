//
//  PushButtonView.swift
//  Focus Tracker
//
//  Created by Paul Brenner on 6/9/15.
//  Copyright (c) 2015 Insignificant.Info. All rights reserved.
//

import UIKit
import QuartzCore


@IBDesignable
class PushButtonView: UIButton {
    
    @IBInspectable var fillColor: UIColor = UIColor.greenColor()
    @IBInspectable var isStartButton: Bool = false
    @IBInspectable var isStopButton: Bool = false
    @IBInspectable var isPauseButton: Bool = false
    @IBInspectable var isLostFocusButton: Bool = false
    
    override func drawRect(rect: CGRect) {
        
        if isStartButton || isStopButton || isPauseButton {
            let circle = UIBezierPath(ovalInRect: rect)
            fillColor.setFill()
            circle.fill()
        } else if isLostFocusButton {
            let roundedRectangle = UIBezierPath(roundedRect: rect, cornerRadius: 10.0)
            fillColor.setFill()
            roundedRectangle.fill()
        }
        
        //set up the width and height variables
        //for the horizontal stroke
//        let boxHeight: CGFloat = 3.0
        let boxWidth: CGFloat = min(bounds.width, bounds.height) * 0.6
        let lineWidth: CGFloat = 3.0
        //create the path
        let square = UIBezierPath()
        let pause = UIBezierPath()
        let triangle = UIBezierPath()
        
        
        //set the path's line width to the height of the stroke
        triangle.lineWidth = lineWidth
        
        //set the stroke color
        UIColor.whiteColor().setStroke()
        
        //Vertical Line
        if isStartButton {
            //move the initial point of the path
            //to the start at upper left corner of triangle
            triangle.moveToPoint(CGPoint(
                x:bounds.width/2 - boxWidth/3 + 0.5,
                y:bounds.height/2 + boxWidth/2 + 0.5))
            
            //add a point to the path at the right point of the
            triangle.addLineToPoint(CGPoint(
                x:bounds.width/2 + boxWidth/2 + 0.5,
                y:bounds.height/2 + 0.5))
            
            //add a point to bottom left of triangle
            triangle.addLineToPoint(CGPoint(
                x:bounds.width/2 - boxWidth/3 + 0.5,
                y:bounds.height/2 - boxWidth/2 + 0.5))
            
            //close triangle
            //triangle.addLineToPoint(CGPoint(
               // x:bounds.width/2 - boxWidth/2 + 0.5,
              //  y:bounds.height/2 + boxWidth/2 + 0.5))
            
            triangle.closePath()
            
            triangle.stroke()
            UIColor.whiteColor().setFill()
            triangle.fill()
        
        }
        if isStopButton {
            
            square.lineWidth = lineWidth
            
            //move the initial point of the path
            //to the start of the horizontal stroke
            square.moveToPoint(CGPoint(
                x:bounds.width/2 - boxWidth/4 + 0.5,
                y:bounds.height/2 + boxWidth/4 + 0.5))
            
            //add a point to the path at the end of the stroke
            square.addLineToPoint(CGPoint(
                x:bounds.width/2 + boxWidth/4 + 0.5,
                y:bounds.height/2 + boxWidth/4 + 0.5))
            
            square.addLineToPoint(CGPoint(
                x:bounds.width/2 + boxWidth/4 + 0.5,
                y:bounds.height/2 - boxWidth/4 + 0.5))
            
            square.addLineToPoint(CGPoint(
                x:bounds.width/2 - boxWidth/4 + 0.5,
                y:bounds.height/2 - boxWidth/4 + 0.5))
            
            square.closePath()
            
            square.stroke()
            UIColor.whiteColor().setFill()
            square.fill()
            
        }
        if isPauseButton {
            pause.lineWidth = 6.0
            pause.moveToPoint(CGPoint(
                x:bounds.width/2 - boxWidth/8 + 0.5,
                y:bounds.width/2 + boxWidth/4 + 0.5))
            
            pause.addLineToPoint(CGPoint(
                x:bounds.width/2 - boxWidth/8 + 0.5,
                y:bounds.width/2 - boxWidth/4 + 0.5))

            pause.moveToPoint(CGPoint(
                x:bounds.width/2 + boxWidth/8 + 0.5,
                y:bounds.width/2 + boxWidth/4 + 0.5))
            
            pause.addLineToPoint(CGPoint(
                x:bounds.width/2 + boxWidth/8 + 0.5,
                y:bounds.width/2 - boxWidth/4 + 0.5))
            
            pause.stroke()
        }
    
    }
    
    
}

