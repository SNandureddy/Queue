//
//  CustomImageView.swift
//  Queue
//
//  Created by Inder on 09/11/16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //MARK : - Variables
    var backgroundView:UIView!

    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    override func draw(_ rect: CGRect) {
    }
    
    func setUpView()  {
        //adding gesture to image view from zooming over the UIWindow
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer? = nil) {
        
        if backgroundView == nil {
            backgroundView = UIView()
            backgroundView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            backgroundView.backgroundColor = UIColor.black
            
            let image = self.image
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            imageView.contentMode = .scaleAspectFit
            backgroundView.addSubview(imageView)
            
            let win:UIWindow = UIApplication.shared.delegate!.window!!
            win.addSubview(self.backgroundView)
            backgroundView.alpha = 0.0
            backgroundView.fadeIn(duration: 0.5)
            
            //adding gesture to backgroundView from zoom out from the UIWindow
            let tapGestureRecognizerForBackGroundView = UITapGestureRecognizer(target: self, action: #selector(backGroundViewTapped))
            backgroundView.isUserInteractionEnabled = true
            backgroundView.addGestureRecognizer(tapGestureRecognizerForBackGroundView)
        }
    }
    
    @objc func backGroundViewTapped(sender: UITapGestureRecognizer? = nil) {
        backgroundView.fadeOut(duration: 0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.backgroundView.removeFromSuperview()
            self.backgroundView = nil
        }
    }
}
