//
//  ViewController.swift
//  PPPopView
//
//  Created by weifans on 16/1/4.
//  Copyright © 2016年 weifans. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNavigation()
        self.initDemo()
    }
    
    func initDemo() {
        let imageView = UIImageView(frame: CGRectMake(0, 0, boundW, boundW))
        imageView.image = UIImage(named: "image")
        self.view.addSubview(imageView)
        
        let paipou = UILabel(frame: CGRectMake(0, boundH-50, boundW, 50))
        paipou.textAlignment = .Center
        paipou.text = "www.paipou.com"
        self.view.addSubview(paipou)
    }
    
    func initNavigation() {
        let popButton = UIButton(frame: CGRectMake(0, 0, 30, 30))
        popButton.setImage(UIImage(named: "more"), forState: .Normal)
        popButton.addTarget(self, action: Selector("more:"), forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: popButton)
    }
    
    
    func more(button: UIButton) {
        let titles = [["title": "微信", "icon": "weixin"], ["title": "朋友圈", "icon": "friend-quan"], ["title": "微博", "icon": "weibo"]]
        view.window?.showPopView(titles, closure: { (closure: Int) -> Void in
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

