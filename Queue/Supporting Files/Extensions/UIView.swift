    //
//  UIView.swift
//  HealthSplash
//
//  Created by Apple on 16/11/17.
//  Copyright © 2017 Deftsfot. All rights reserved.
//

import Foundation
import UIKit

typealias animationCallBack = ((Bool) -> ())

extension UIView {
    
    var half: CGFloat {
        return self.frame.height/2
    }
    
    func set(radius: CGFloat, borderColor: UIColor = UIColor.clear, borderWidth: CGFloat = 0.0) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
    
    func setShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.4
    }
    
    func generateShadowUsingBezierPath(radius: CGFloat)  {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
        
        let shadow = UIView(frame: self.frame)
        shadow.backgroundColor = .white
        shadow.isUserInteractionEnabled = false
        shadow.layer.shadowColor = UIColor.black.cgColor
        shadow.layer.shadowOffset = .zero
        shadow.layer.shadowRadius = 2.0
        shadow.layer.masksToBounds = false
        shadow.layer.cornerRadius = self.layer.cornerRadius
        shadow.layer.shadowOpacity = 0.3
        self.superview?.addSubview(shadow)
        self.superview?.sendSubviewToBack(shadow)
    }
    
    func setGradient(color1: UIColor, color2: UIColor, frame: CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ color1.cgColor, color2.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = frame
        self.layer.sublayers?.insert(gradientLayer, at: 0)
    }
    
    func fadeIn(duration: TimeInterval = 0.3) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeOut(duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
}

class Slider : UISlider {
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 5.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
}

extension UIView{
    
    func showWithBottomUpAnimation(yOrigin:CGFloat, animationSpeed:Double! = 0.5, callBack:@escaping animationCallBack){
        
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        UIView.animate(withDuration: animationSpeed, animations: {
            self.frame = CGRect(x: 0, y: yOrigin, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }) { (status) in
            self.frame = CGRect(x: 0, y: yOrigin, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            callBack(true)
        }
        
        
        
    }
    
    func hideWithUpDownAnimation(yOrigin:CGFloat, animationSpeed:Double! = 0.5, callBack:@escaping animationCallBack)  {
        self.frame = CGRect(x: 0, y: yOrigin, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        UIView.animate(withDuration: animationSpeed, animations: {
            self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }) { (status) in
            self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            callBack(true)
        }
        
    }
    
    
}
