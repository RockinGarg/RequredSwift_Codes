//
//  Tri_CurvedView_Right.swift
//  ServiceAppBasicDesigns
//
//  Created by IosDeveloper on 20/04/18.
//  Copyright © 2018 iOSDeveloper. All rights reserved.
//

import UIKit

//MARK:- Tri_CurvedView_Right
/**
 This class is used to add a curved view with Right sided arrow 
 */
class Tri_CurvedView_Right: UIView
{
    //// Background color
    var baseColor:UIColor?
    /// Arrow Starting Distance
    var startingDistance:CGFloat?
    /// Arrow Width
    var arrowWidth:CGFloat?
    /// Arrow Height
    var arrowHeight:CGFloat?
    
    //MARK: Initialise Class
    /**
     This function is used to Initialise the class
     - parameter frame : Frame of Canvas
     - parameter Base_Color : Canvas Drawn View Background color
     */
    init(frame:CGRect,Base_Color:UIColor) {
        super.init(frame: frame)
        /// Set BackGround Color as Clear
        self.backgroundColor = UIColor.clear
        /// Set Required Properties
        self.baseColor = Base_Color
        /// Set Arrow Starting Distance
        self.startingDistance = frame.size.width*0.08
        /// Set Arrow Width
        self.arrowWidth = frame.size.width*0.11
        /// Set Arrow Height
        self.arrowHeight = frame.size.height*0.06
    }
    
    //MARK: Draw The Traingle
    /**
     This function is used Draw Views inside Rect
     - parameter rect : Frame
     */
    override func draw(_ rect: CGRect) {
        /// Get Rect Values
        let minx = rect.minX, maxx = rect.maxX
        let miny = rect.minY, maxy = rect.maxY
        /// Outer Boundry Path
        let boundryPath = CGMutablePath()
        boundryPath.move(to: CGPoint(x: minx+startingDistance!, y: miny+arrowHeight!))
        boundryPath.addQuadCurve(to: CGPoint(x: minx, y: miny+arrowHeight!+startingDistance!), control: CGPoint(x: minx, y: miny+arrowHeight!))
        boundryPath.addLine(to: CGPoint(x: minx, y: maxy-startingDistance!))
        
        boundryPath.addQuadCurve(to: CGPoint(x: minx+startingDistance!, y: maxy), control: CGPoint(x: minx, y: maxy))
        boundryPath.addLine(to: CGPoint(x: maxx-startingDistance!, y: maxy))
        
        boundryPath.addQuadCurve(to: CGPoint(x: maxx, y: maxy-startingDistance!), control: CGPoint(x: maxx, y: maxy))
        boundryPath.addLine(to: CGPoint(x: maxx, y: miny+startingDistance!+arrowHeight!))
        
        boundryPath.addQuadCurve(to: CGPoint(x: maxx-startingDistance!, y: miny+arrowHeight!), control: CGPoint(x: maxx, y: miny+arrowHeight!))
        boundryPath.addLine(to: CGPoint(x: maxx-startingDistance!-(arrowWidth!/2), y: miny))
        boundryPath.addLine(to: CGPoint(x: maxx-startingDistance!-arrowWidth!, y: miny+arrowHeight!))
        boundryPath.closeSubpath()
        /// Final Layer
        let finalDrawnLayer = CAShapeLayer()
        finalDrawnLayer.path = boundryPath
        finalDrawnLayer.shadowColor = UIColor.black.cgColor
        finalDrawnLayer.shadowOffset = CGSize(width: 0, height: 0)
        finalDrawnLayer.shadowOpacity = 0.2
        finalDrawnLayer.shadowRadius = 6
        finalDrawnLayer.fillColor = (self.baseColor?.cgColor)!
        self.layer.addSublayer(finalDrawnLayer)
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
        startingDistance=nil
        arrowWidth=nil
        arrowHeight=nil
    }

}
