//
//  PopView.swift
//  Paipou
//
//  Created by weifans on 16/1/3.
//  Copyright © 2016年 weifans. All rights reserved.
//

import UIKit

let bound = UIScreen.mainScreen().bounds
let boundW = bound.size.width
let boundH = bound.size.height

class PopView: UIView {

    var popScrollView: UIScrollView!
    var indexClosure:((Int)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.backgroundColor = UIColor.whiteColor()
        blurView.frame = CGRectMake(0, 0, boundW, boundH)
        blurView.alpha = 0.8
        self.addSubview(blurView)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPopScrollView() {
        popScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: boundW, height: 160))
        popScrollView.backgroundColor = UIColor.clearColor()
        popScrollView.contentSize = CGSizeMake(60 * 5 + 6 * 10, 100);
        popScrollView.showsHorizontalScrollIndicator = false;
        popScrollView.pagingEnabled = false;
        self.addSubview(popScrollView)
    }
    
    
    func setupSubViews(titles: [[String: String]]) {
        
        frame = CGRectMake(0, boundH-210, boundW, 210)
        
        self.initPopScrollView()
        
        var i  = 0
        
        let w = 60
        let h = 60
        let margin = 20
        let startX = 20
        
        for title in titles {

            let titleButton = UIButton()
            titleButton.setImage(UIImage(named: title["icon"]!), forState: .Normal)
            titleButton.layer.cornerRadius = 10
            titleButton.layer.masksToBounds = true
            titleButton.tag = i

            let titleLabel = UILabel()
            titleLabel.font = UIFont.systemFontOfSize(12)
            titleLabel.textColor = UIColor.grayColor()
            titleLabel.textAlignment = .Center
            titleLabel.text = title["title"]
            
            let column = i % titles.count
            let x = startX + column * (w + margin)
            
            titleButton.frame = CGRectMake(CGFloat(Float(x)), 20, CGFloat(Float(w)), CGFloat(Float(h)))
            titleLabel.frame = CGRectMake(CGFloat(Float(x)), 85, CGFloat(Float(w)), 20)
            
            popScrollView.addSubview(titleButton)
            popScrollView.addSubview(titleLabel)
            
            i++
        }
        
        //取消按钮
        let cancelButton = UIButton(frame: CGRectMake(0, 160, boundW, 50))
        
        cancelButton.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:0.9)
        cancelButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        cancelButton.setTitle("取消", forState: UIControlState.Normal)
        
        cancelButton.addTarget(self, action: Selector("cancel:"), forControlEvents: .TouchDown)
        cancelButton.addTarget(self, action: Selector("cancelUpInside:"), forControlEvents: .TouchUpInside)
        cancelButton.addTarget(self, action: Selector("cancelUpOutside:"), forControlEvents: .TouchUpOutside)
        addSubview(cancelButton)
    }
    
    
    func whenButton(button: UIButton) {
        button.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:0.3)
    }
    
    func whenButtonUpInside(button: UIButton) {
        self.whenButtonUpOutside(button)
        
        window?.dismissPopView()
        if let closure = indexClosure {
            closure(button.tag)
        } else {
            print("you need assign to closure")
        }
    }
    
    func whenButtonUpOutside(button: UIButton) {
        button.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:0.9)
    }
    
    func cancel(button: UIButton) {
        button.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:0.3)
    }
    
    func cancelUpInside(button: UIButton) {
        self.cancelUpOutside(button)
        window?.dismissPopView()
    }
    
    func cancelUpOutside(button: UIButton) {
        button.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:0.9)
    }
}

class MaskView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.blackColor()
        self.frame = UIScreen.mainScreen().bounds
        alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        window?.dismissPopView()
    }
    
}


extension UIWindow {
    
    
    func showPopView(titles: [[String: String]], closure:((Int)->Void)? ) {
        let maskView = MaskView(frame: CGRectZero)
        self.addSubview(maskView)
        let popView = PopView(frame: CGRectZero)
        self.addSubview(popView)
        
        popView.indexClosure = closure
        popView.setupSubViews(titles)
        
        UIView.animateWithDuration(0.3, animations: {
            maskView.alpha = 0.3
            popView.frame = CGRectMake(0, boundH-210, boundW, 210)
        })
    }
    
    //消失popView
    func dismissPopView() {
        
        let count = self.subviews.count
        let maskView = self.subviews[count-2] as! MaskView
        let popView = self.subviews[count-1] as! PopView
        
        UIView.animateWithDuration(0.3, animations: {
            maskView.alpha = 0
            popView.frame = CGRect(x: 0, y: boundH, width: boundW, height: popView.frame.height)
        }) { (completion:Bool) -> Void in
            maskView.removeFromSuperview()
            popView.removeFromSuperview()
        }
    }
}