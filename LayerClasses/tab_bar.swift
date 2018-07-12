//
//  circleShape.swift
//  shapeLayer_demo
//
//  Created by IosDeveloper on 27/04/18.
//  Copyright © 2018 ServiceApp. All rights reserved.
//

import UIKit

//MARK:- circleShape
/**
 This class is used to add a circle shaped View with Shadow
 */
class circleShape: UIView
{
    //// Background color
    var baseColor:UIColor?
    
    //MARK: Initialise Class
    /**
     This function is used to Initialise the class
     - parameter frame : Frame of Canvas
     - parameter Base_Color : Canvas Drawn View Background color
     */
    init(frame:CGRect,Base_Color:UIColor)
    {
        super.init(frame: frame)
        /// Set BackGround Color as Clear
        self.backgroundColor = UIColor.clear
        /// Set Required Properties
        self.baseColor = Base_Color
        if baseColor == nil {
            baseColor = UIColor.white
        }
    }
    
    //MARK: Draw The Traingle
    /**
     This function is used Draw Views inside Rect
     - parameter rect : Frame
     */
    override func draw(_ rect: CGRect)
    {
        let circlePath = UIBezierPath()
        let circleLayer = CAShapeLayer()
        let midy = rect.midY, midx = rect.midX
        circlePath.addArc(withCenter: CGPoint(x: midx, y: midy), radius: rect.size.width/2-2, startAngle: 0, endAngle: (CGFloat(2 * Double.pi)), clockwise: true)
        circleLayer.path = circlePath.cgPath
        circleLayer.shadowColor = UIColor.black.cgColor
        circleLayer.shadowOffset = CGSize(width: 0, height: 0)
        circleLayer.shadowOpacity = 0.2
        circleLayer.shadowRadius = 6
        if baseColor == nil {
            circleLayer.fillColor = UIColor.white.cgColor
        }
        else{
            circleLayer.fillColor = baseColor?.cgColor
        }
        
        self.layer.insertSublayer(circleLayer, at: 0)
    }

    //MARK: Encoder
    /**
     This function is used to Store the class objects added
     */
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    ///MARK: Dienit class
    /**
     This function is used to De-Allocate the class objects
     */
    deinit {
        /// Remove all The Initiated Instances
        baseColor=nil
    }
}

//MARK:- tabBarBaseShape
/**
 This class is used to add a Curved view as Tab Bar
 */
class tabBarBaseShape: UIView
{
    //// Background color
    var baseColor:UIColor?
    /// Distance for curve
    var curveDistance : CGFloat?
    /// height
    var shapeHeight : CGFloat?
    
    //MARK: Initialise Class
    /**
     This function is used to Initialise the class
     */
    init(frame:CGRect,Base_Color:UIColor) {
        super.init(frame: frame)
        /// Set BackGround Color as Clear
        self.backgroundColor = UIColor.clear
        /// Set Required Properties
        self.baseColor = Base_Color
        self.curveDistance = self.frame.size.width*0.1
        self.shapeHeight = self.frame.size.height*0.7
    }
    
    //MARK: Draw The Traingle
    /**
     This function is used Draw Views inside Rect
     - parameter rect : Frame
     */
    override func draw(_ rect: CGRect) {
        /// Get Rect Values
        let minx = rect.minX, maxx = rect.maxX
        let _ = rect.minY, maxy = rect.maxY
        /// Shape Path
        let shapePath = CGMutablePath()
        shapePath.move(to: CGPoint(x: minx, y: maxy))
        /// First curve
        shapePath.addQuadCurve(to: CGPoint(x: minx+curveDistance!, y: maxy-shapeHeight!), control: CGPoint(x: minx, y: maxy-shapeHeight!))
        shapePath.addLine(to: CGPoint(x: maxx-curveDistance!, y: maxy-shapeHeight!))
        /// Second Curve
        shapePath.addQuadCurve(to: CGPoint(x: maxx, y: maxy), control: CGPoint(x: maxx, y: maxy-shapeHeight!))
        shapePath.closeSubpath()
        
        /// Final Layer
        let finalDrawnLayer = CAShapeLayer()
        finalDrawnLayer.path = shapePath
        finalDrawnLayer.shadowColor = UIColor.black.cgColor
        finalDrawnLayer.shadowOffset = CGSize(width: 0, height: 0)
        finalDrawnLayer.shadowOpacity = 0.2
        finalDrawnLayer.shadowRadius = 6
        finalDrawnLayer.fillColor = (self.baseColor?.cgColor)!
        self.layer.insertSublayer(finalDrawnLayer, at: 0)
    }
    
    //MARK: Encoder
    /**
     This function is used to Store the class objects added
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Dienit class
    /**
     This function is used to De-Allocate the class objects
     */
    deinit {
        /// Remove all The Initiated Instances
        baseColor=nil
    }
}
