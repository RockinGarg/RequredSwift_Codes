//
//  Pulsator.swift
//  Pulsator
//
//  Created by Shuichi Tsutsumi on 4/9/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//
//  Objective-C version: https://github.com/shu223/PulsingHalo


import UIKit
import QuartzCore

///kPulsator Animation Key
internal let kPulsatorAnimationKey = "pulsator"

//MARK: Pulsator main class
/**
 This class Handl All the required operations Required to generate Pulses Around a View
*/
open class Pulsator: CAReplicatorLayer, CAAnimationDelegate
{
    ///CALayer
    fileprivate let pulse = CALayer()
    
    ///Animation Group - Asunc Mode
    fileprivate var animationGroup: CAAnimationGroup!
    
    ///Static Alpha value
    fileprivate var alpha: CGFloat = 0.45

    ///Set Background Color
    override open var backgroundColor: CGColor? {
        didSet {
            pulse.backgroundColor = backgroundColor
            guard let backgroundColor = backgroundColor else {return}
            let oldAlpha = alpha
            alpha = backgroundColor.alpha
            if alpha != oldAlpha {
                recreate()
            }
        }
    }
    
    ///Repeat Count - Open Propert that is set to show number of Waves
    override open var repeatCount: Float {
        didSet {
            if let animationGroup = animationGroup {
                animationGroup.repeatCount = repeatCount
            }
        }
    }
    
    // MARK: - Public Properties

    /// The number of pulse.
    open var numPulse: Int = 1 {
        didSet {
            if numPulse < 1 {
                numPulse = 1
            }
            instanceCount = numPulse
            updateInstanceDelay()
        }
    }
    
    ///	The radius of pulse.
    open var radius: CGFloat = 60 {
        didSet {
            updatePulse()
        }
    }
    
    /// The animation duration in seconds.
    open var animationDuration: TimeInterval = 3 {
        didSet {
            updateInstanceDelay()
        }
    }
    
    /// If this property is `true`, the instanse will be automatically removed
    /// from the superview, when it finishes the animation.
    open var autoRemove = false
    
    /// fromValue for radius
    /// It must be smaller than 1.0
    open var fromValueForRadius: Float = 0.0 {
        didSet {
            if fromValueForRadius >= 1.0 {
                fromValueForRadius = 0.0
            }
            recreate()
        }
    }
    
    /// The value of this property should be ranging from @c 0 to @c 1 (exclusive).
    open var keyTimeForHalfOpacity: Float = 0.2 {
        didSet {
            recreate()
        }
    }
    
    /// The animation interval in seconds.
    open var pulseInterval: TimeInterval = 0
    
    /// A function describing a timing curve of the animation.
    open var timingFunction: CAMediaTimingFunction? = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault) {
        didSet {
            if let animationGroup = animationGroup {
                animationGroup.timingFunction = timingFunction
            }
        }
    }
    
    /// The value of this property showed a pulse is started
    open var isPulsating: Bool {
        guard let keys = pulse.animationKeys() else {return false}
        return keys.count > 0
    }
    
    /// private properties for resuming
    fileprivate weak var prevSuperlayer: CALayer?
    fileprivate var prevLayerIndex: Int?
    
    // MARK: - Initializer
    /**
     This function is public assignable and used to initialise class
     */
    override public init()
    {
        super.init()
        //Start Pulses
        setupPulse()
        
        ///Delay Interval
        instanceDelay = 1
        repeatCount = MAXFLOAT
        backgroundColor = UIColor(red: 0, green: 0.455, blue: 0.756, alpha: 0.45).cgColor
        
        ///Notification Observers
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(resume),name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    //MARK: Initialiser
    /**
     This function is used to initialise class view in memory
     */
    override public init(layer: Any)
    {
        super.init(layer: layer)
    }
    
    //MARK: Coder
    /**
     Encode class
     */
    required public init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Dienit - Kills All Memorry Used
    /**
     This function is used to remove all the notificaton observers
     */
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private Methods
    //MARK: Start Pulses
    /**
     This function is to Start the Pulse in Start Function
     */
    fileprivate func setupPulse()
    {
        pulse.contentsScale = UIScreen.main.scale
        pulse.opacity = 0
        addSublayer(pulse)
        updatePulse()
    }
    
    //MARK: Set CAAnimation Group
    /**
     This function is used to set animation group that will hanlde all the naimation with different scaling
     */
    fileprivate func setupAnimationGroup()
    {
        ///Animation Scale
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = fromValueForRadius
        scaleAnimation.toValue = 1.0
        scaleAnimation.duration = animationDuration
        
        ///Opacity
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.values = [alpha, alpha * 0.5, 0.0]
        opacityAnimation.keyTimes = [0.0, NSNumber(value: keyTimeForHalfOpacity), 1.0]
        
        ///Set Group Values
        animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        animationGroup.duration = animationDuration + pulseInterval
        animationGroup.repeatCount = repeatCount
        
        if let timingFunction = timingFunction
        {
            animationGroup.timingFunction = timingFunction
        }
        animationGroup.delegate = self
    }
    
    //MARK: Update Pulse
    /**
     This function is used to update the pulse with different Opcaity and lighter backGround
     */
    fileprivate func updatePulse()
    {
        let diameter: CGFloat = radius * 2
        pulse.bounds = CGRect(
            origin: CGPoint.zero,
            size: CGSize(width: diameter, height: diameter))
        pulse.cornerRadius = radius
        pulse.backgroundColor = backgroundColor
    }
    
    //MARK: Update Delay
    /**
     This function is used to update the delay for each new pulse getting created
     */
    fileprivate func updateInstanceDelay()
    {
        guard numPulse >= 1 else { fatalError() }
        instanceDelay = (animationDuration + pulseInterval) / Double(numPulse)
    }
    
    // MARK: Recreate Animation
    /**
     This function is to Recreate the state of Execution from begining
     */
    fileprivate func recreate()
    {
        guard animationGroup != nil else { return }        // Not need to be recreated.
        stop()
        let when = DispatchTime.now() + Double(Int64(0.2 * double_t(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: when) { () -> Void in
            self.start()
        }
    }
    
    // MARK: Save Context
    /**
     This function is to save the state of Execution
     */
    @objc internal func save()
    {
        prevSuperlayer = superlayer
        prevLayerIndex = prevSuperlayer?.sublayers?.index(where: {$0 === self})
    }

    //MARK: Resume Animation
    /**
     This function is used to resume Aniation
     */
    @objc internal func resume()
    {
        if let prevSuperlayer = prevSuperlayer, let prevLayerIndex = prevLayerIndex
        {
            prevSuperlayer.insertSublayer(self, at: UInt32(prevLayerIndex))
        }
        
        if pulse.superlayer == nil
        {
            addSublayer(pulse)
        }
        
        let isAnimating = pulse.animation(forKey: kPulsatorAnimationKey) != nil
        
        // if the animationGroup is not nil, it means the animation was not stopped
        if let animationGroup = animationGroup, !isAnimating
        {
            pulse.add(animationGroup, forKey: kPulsatorAnimationKey)
        }
    }

    
    //MARK: Start the animation.
    /**
     This function is public and make animation group to start execution
    */
    open func start()
    {
        setupPulse()
        setupAnimationGroup()
        pulse.add(animationGroup, forKey: kPulsatorAnimationKey)
    }
    
    //MARK: Stop the animation.
    /**
     This function is public and make animation group to Stop execution
     */
    open func stop()
    {
        pulse.removeAllAnimations()
        animationGroup = nil
    }
    
    
    // MARK: Delegate methods for CAAnimation
    /**
     This function executes when Animation is stopped and manage Proper Execution of that stop FUnction functionality
     */
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
    {
        if let keys = pulse.animationKeys(), keys.count > 0
        {
            pulse.removeAllAnimations()
        }
        
        pulse.removeFromSuperlayer()
        
        if autoRemove
        {
            removeFromSuperlayer()
        }
    }
}
