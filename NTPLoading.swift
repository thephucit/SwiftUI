/*
 * @package NTPLoading.swift
 * @author The Phuc
 * @since 7/10/2016.
 */

import Foundation
import UIKit

class NTPLoading {
    
    var loadingView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    func show() {
        let win:UIWindow = UIApplication.sharedApplication().delegate!.window!!
        self.loadingView = UIView(frame: win.frame)
        self.loadingView.tag = 1
        self.loadingView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        win.addSubview(self.loadingView)
        activityIndicator.frame = CGRectMake(0, 0, win.frame.width/5, win.frame.width/5)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.center = self.loadingView.center
        activityIndicator.color = UIColor.blackColor()
        self.loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func hide(){
        UIView.animateWithDuration(0.0, delay: 1.0, options: .CurveEaseOut, animations: {
            self.loadingView.alpha = 0.0
            self.activityIndicator.stopAnimating()
            }, completion: { finished in
                self.activityIndicator.removeFromSuperview()
                self.loadingView.removeFromSuperview()
                let win:UIWindow = UIApplication.sharedApplication().delegate!.window!!
                let removeView  = win.viewWithTag(1)
                removeView?.removeFromSuperview()
        })
    }
}