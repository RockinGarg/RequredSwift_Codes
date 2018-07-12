//
//  customLoaderAnim.swift
//  serivceApp-Components
//
//  Created by IosDeveloper on 18/05/18.
//  Copyright © 2018 rockinGarg. All rights reserved.
//

import UIKit

class customLoaderAnim: UIView,Explodable {

    let ovalLayer = OvalLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    //MARK: Encoder
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    func addOval() {
        layer.addSublayer(ovalLayer)
        ovalLayer.addExpandAnimation()
        Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(customLoaderAnim.wobbleOval),
                                               userInfo: nil, repeats: false)
        
    }
    
    @objc func wobbleOval() {
        ovalLayer.wobble()
        ovalLayer.wobble()
    }
    
    

}
