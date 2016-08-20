/*
 * @package NTPAlert.swift
 * @author The Phuc
 * @since 7/10/2016.
 */

import UIKit
class NTPAlert: UIView {
    
    enum Style {
        case Success
        case Warning
        case Error
        case Info
    }
    
    private var SCREEN_WIDTH: CGFloat = 0.0
    private var SCREEN_HEIGHT: CGFloat = 0.0
    private var yAlert: CGFloat = 0.0
    private var tagOfAlert: Int = 1601
    
    private var win: UIViewController = UIViewController()
    private var message: String = String()
    private var backgroundCL: UIColor = UIColor()
    private var messageCL: UIColor = UIColor()
    private var delay: NSTimeInterval = NSTimeInterval()
    
    init(win: UIViewController, message: String, type: Style = Style.Success, delay: NSTimeInterval = 3, marginBottom: CGFloat = 20.0) {
        SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
        SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
        switch type {
        case Style.Success:
            self.backgroundCL = UIColor(hue: 0.2278, saturation: 0.21, brightness: 0.94, alpha: 1.0)
            self.messageCL = UIColor(hue: 0.2472, saturation: 0.88, brightness: 0.54, alpha: 1.0)
        case Style.Warning:
            self.backgroundCL = UIColor(hue: 0.1333, saturation: 0.29, brightness: 0.99, alpha: 1.0)
            self.messageCL = UIColor(hue: 0.1, saturation: 1, brightness: 0.62, alpha: 1.0)
        case Style.Error:
            self.backgroundCL = UIColor(hue: 0, saturation: 0.27, brightness: 1, alpha: 1.0)
            self.messageCL = UIColor(hue: 0.9917, saturation: 1, brightness: 0.84, alpha: 1.0)
        case Style.Info:
            self.backgroundCL = UIColor(hue: 0.5528, saturation: 0.23, brightness: 0.97, alpha: 1.0)
            self.messageCL = UIColor(hue: 0.5778, saturation: 1, brightness: 0.6, alpha: 1.0)
        }
        let marginLeft:CGFloat = 20.0
        let fontMessage = UIFont(name: "Arial", size: 13)
        var widthAlert:CGFloat = SCREEN_WIDTH - marginLeft * 2
        if SCREEN_WIDTH > 414 { widthAlert = (SCREEN_WIDTH - marginLeft * 2) / 2 }
        let heightAlert = message.heightText(fontMessage!, width: widthAlert) + marginLeft
        yAlert = SCREEN_HEIGHT - heightAlert - marginBottom
        let xAlert: CGFloat = SCREEN_WIDTH - marginLeft - widthAlert
        super.init(frame: CGRect(x: xAlert, y: SCREEN_HEIGHT, width: widthAlert, height: heightAlert))
        self.win = win
        self.delay = delay
        self.backgroundColor = self.backgroundCL
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NTPAlert.handleTap(_:))))
        /* add message */
        let lblMessage: UILabel = UILabel(frame: CGRect(x: marginLeft, y: 0, width: widthAlert - marginLeft * 2, height: heightAlert))
        lblMessage.text = message
        lblMessage.font = fontMessage
        lblMessage.textColor = messageCL
        lblMessage.lineBreakMode = NSLineBreakMode.ByWordWrapping
        lblMessage.numberOfLines = 0
        lblMessage.textAlignment = .Left
        self.addSubview(lblMessage)
    }
    
    @objc private func handleTap(tapGesture: UITapGestureRecognizer) {
        self.fadeOut()
    }
    
    internal func show(){
        self.alpha = 0
        self.win.view.addSubview(self)
        self.fadeIn()
        NTPAlert_AutoHide(self.delay) { self.fadeOut() }
    }
    
    func fadeIn() {
        if (self.win.view.viewWithTag(tagOfAlert) == nil) {
            self.tag = tagOfAlert
            UIView.animateWithDuration(0.5) {
                self.alpha = 1.0
                self.frame.origin.y = self.yAlert
            }
        }
    }
    
    func fadeOut(duration: NSTimeInterval = 0.3, delay: NSTimeInterval = 0, completion: (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 0.0
            self.removeFromSuperview()
            }, completion: completion)
    }
    
    @objc private func NTPAlert_AutoHide(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    override func layoutSubviews(){
        self.backgroundColor = backgroundCL
        layer.opacity = 0.95
        layer.cornerRadius = 5
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 2)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowOpacity = 0.2
        layer.shadowPath = shadowPath.CGPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension String {
    func heightText(font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.height
    }
}