//
//  UploadFile.swift
//  Service App-Provider
//
//  Created by IosDeveloper on 06/06/18.
//  Copyright © 2018 serviceApp. All rights reserved.
//

import Foundation
import UIKit

class animationClass : NSObject
{
    class func animateCell(cell: UITableViewCell)
    {
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.fromValue = 200
        cell.layer.cornerRadius = 0
        animation.toValue = 0
        animation.duration = 1
        cell.layer.add(animation, forKey: animation.keyPath)
    }
    
    class  func animateCellAtIndexPath(indexPath: NSIndexPath, tableViewView:UITableView)
    {
        guard  let cell = tableViewView.cellForRow(at: indexPath as IndexPath) else { return }
        animateCell(cell: cell)
    }
 
    //MARK: Not Working
    class func forwardView(view:UIView) -> Void {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            view.layoutSubviews()
        }) { (succeed) -> Void in
            
        }
    }
    
    //MARK: Not Working
    class func reverseView(view:UIView) -> Void {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            view.transform = CGAffineTransform(rotationAngle: CGFloat(-180 * Double.pi))
            view.layoutSubviews()
        }) { (succeed) -> Void in
        }
    }
  
}

//MARK:- My Animations
extension animationClass
{
    
    class func animateTextLabels(_ textLabel: UILabel) {
        let isExpandedMode = self.extensionContext?.widgetActiveDisplayMode == .expanded
        let scaleText:CGFloat = isExpandedMode ? 3 : 0.3
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            textLabel.transform = .init(scaleX: scaleText, y: scaleText)
            dateLabel.transform = isExpandedMode ? .init(translationX: 0, y: 20) : .identity
        }) { (finished) in
            UIView.animate(withDuration: 0.3, animations: {
                textLabel.transform = .identity
            })
        }
    }
    
    //MARK: Damping Effect
    class func dampingEffect(view:UIView) -> Void {
        view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0,initialSpringVelocity: 1.0,options: .allowUserInteraction, animations: { [weak view] in
            view?.transform = .identity
            },completion: nil)
    }
    
    //MARK: Animate View in Ellipse Moving
    class func animateCarLayerPosition(){
        let orbitAnimation = CAKeyframeAnimation()
        orbitAnimation.keyPath = "position"
        orbitAnimation.path = CGPath(ellipseIn: boundingRect!, transform: nil)
        orbitAnimation.duration = 4
        orbitAnimation.isAdditive = true
        orbitAnimation.repeatCount = Float.greatestFiniteMagnitude
        orbitAnimation.calculationMode = kCAAnimationPaced
        orbitAnimation.rotationMode = kCAAnimationRotateAuto
        carImageView.layer.add(orbitAnimation, forKey: "animLayer")
    }
    
    //MARK: Shake Animation
    class func shakeAnimation(){
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [ 0, 10, -10, 10, 0 ]
        animation.keyTimes = [ 0.0, (1 / 6.0), (3 / 6.0), (5 / 6.0), 1.0 ] as [NSNumber]
        animation.duration = 0.4
        animation.repeatCount = 4
        animation.isAdditive = true
        ErrorBaseView.layer.add(animation, forKey: "shake")
    }
    
    //MARK: Animate View at its Position - chakkar 1
    class func runSpinAnimationOnView(view:UIView , duration:Float, rotations:Double, repeatt:Float ) ->() {
        let rotationAnimation=CABasicAnimation();
        rotationAnimation.keyPath="transform.rotation.z"
        let toValue = Double.pi * 2.0 * rotations ;
        let someInterval = CFTimeInterval(duration)
        
        rotationAnimation.toValue=toValue;
        rotationAnimation.duration=someInterval;
        rotationAnimation.isCumulative=true;
        rotationAnimation.repeatCount=repeatt;
        view.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    //MARK: Animate View at its Position - chakkar 2 (+ Rotate in Left, - Rotate in Right)
    func rotateViewAtZ(_ view: UIView){
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = 0
        animation.fromValue = 2.0*CGFloat.pi
        animation.duration = 1
        animation.repeatCount = Float.greatestFiniteMagnitude
        view.layer.add(animation, forKey: "spin")
    }
}

//MARK:- Evidyaa CollectionCell Animation
extension animationClass
{
    func animateCellWithSpring(_ cell: UICollectionViewCell){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [],animations: {
            cell.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        },completion: {
                finished in UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options:[],animations:
                    {
                        cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                },completion: nil)
        })
    }
}

//MARK:- Fade Animation
extension animationClass
{
    //MARK: Fade In
    class func fadeIn(view:UIView) ->Void {
        view.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            view.alpha = 1.0
            view.isHidden = false
        }, completion: nil)
    }
    
    //MARK: Fade Out
    class func fadeOut(view:UIView) ->Void {
        view.alpha = 1.0
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            view.alpha = 0
        }, completion: { finished in
            view.isHidden = true
        })
    }
}

//MARK:- Slide Views
extension animationClass
{
    //MARK: Slide View - Right To Left
    class func viewSlideInFromRightToLeft(view:UIView) -> Void
    {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.layer.add(transition, forKey: kCATransition)
    }
    
    //MARK: Slide View - Left To Right
    class func viewSlideInFromLeftToRight(view:UIView) -> Void {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.layer.add(transition, forKey: kCATransition)
    }
    
    //MARK: Slide View - Top To Bottom
    class func viewSlideInFromTopToBottom(view:UIView) -> Void {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        view.layer.add(transition, forKey: kCATransition)
    }
    
    //MARK: Slide View - Bottom To Top
    class func viewSlideInFromBottomToTop(view:UIView) -> Void {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        view.layer.add(transition, forKey: kCATransition)
    }
}


//MARK:- Flip Animations
extension animationClass
{
    //MARK: Animate From Left To Right
    class func flipViewFromLeftToRight(_ baseView: UIView, _ viewToAdd: UIView, _ viewToRemove: UIView, _ timeDuration: TimeInterval) {
        UIView.transition(with: baseView, duration: timeDuration, options: .transitionFlipFromLeft, animations: {
            baseView.addSubview(viewToAdd)
        }) { (success) in
            if success {
                viewToRemove.removeFromSuperview()
            }
        }
    }
    
    //MARK: Animate From Right To Left
    class func flipViewFromRightToLeft(_ baseView: UIView, _ viewToAdd: UIView, _ viewToRemove: UIView, _ timeDuration: TimeInterval) {
        UIView.transition(with: baseView, duration: timeDuration, options: .transitionFlipFromRight, animations: {
            baseView.addSubview(viewToAdd)
        }) { (success) in
            if success {
                viewToRemove.removeFromSuperview()
            }
        }
    }
    
    //MARK: Animate From Top To Bottom
    func flipViewFromTopToBottom(_ baseView: UIView, _ viewToAdd: UIView, _ viewToRemove: UIView, _ timeDuration: TimeInterval) {
        UIView.transition(with: baseView, duration: timeDuration, options: .transitionFlipFromTop, animations: {
            baseView.addSubview(viewToAdd)
        }) { (success) in
            if success {
                viewToRemove.removeFromSuperview()
            }
        }
    }
    
    //MARK: Animate From Bottom To Top
    func flipViewFromBottomToTop(_ baseView: UIView, _ viewToAdd: UIView, _ viewToRemove: UIView, _ timeDuration: TimeInterval) {
        UIView.transition(with: baseView, duration: timeDuration, options: .transitionFlipFromBottom, animations: {
            baseView.addSubview(viewToAdd)
        }) { (success) in
            if success {
                viewToRemove.removeFromSuperview()
            }
        }
    }
}
