// @package NTPRadio.swift
// @author The Phuc
// @since 7/10/2016

import UIKit

class NTPRadio: UIView
{
    private var SCREEN_WIDTH: CGFloat = CGFloat()
    private var SCREEN_HEIGHT: CGFloat = CGFloat()
    // define image for radio Button
    private var checkedImage = UIImage(named: "Selected")! as UIImage
    private var unCheckedImage = UIImage(named: "unSelected")! as UIImage
    // define element for radio Button
    let radio: UIButton = UIButton()
    let titleDisplay: UILabel = UILabel()
    // variable for save data for selected
    private static var data:[String:String] = [String:String]()
    private static var isSelected:Bool = false
    private var splitStr = "####"
    
    /* Init radio Button */
    init(frame: CGRect, name: String, text: String, value: String, selected: Bool = false, titleColor: UIColor = UIColor(hue: 0.0389, saturation: 0, brightness: 0.36, alpha: 1.0))
    {
        super.init(frame: frame)
        // get screen size
        SCREEN_WIDTH = UIScreen.mainScreen().bounds.width
        SCREEN_HEIGHT = UIScreen.mainScreen().bounds.height
        // config radio button
        radio.frame = CGRectMake(0, 0, frame.height, frame.height)
        if NTPRadio.isSelected == false {
            if selected {
                radio.setBackgroundImage(checkedImage, forState: .Normal)
                NTPRadio.data[name] = value
                NTPRadio.isSelected = true
            } else {
                radio.setBackgroundImage(unCheckedImage, forState: .Normal)
            }
        } else {
            radio.setBackgroundImage(unCheckedImage, forState: .Normal)
        }
        
        radio.titleLabel?.text = name + splitStr + value
        radio.addTarget(self, action: "tappedButton:", forControlEvents: UIControlEvents.TouchUpInside)
        // config text display
        let heightLine = heightLabel(text, font: UIFont(name: "Arial", size: frame.height - 7)!, width: frame.width - frame.height - 5)
        titleDisplay.frame = CGRectMake(frame.height + 7, 0, frame.width - frame.height - 5, heightLine)
        titleDisplay.text = text
        titleDisplay.font = UIFont(name: "Arial", size: frame.height - 7)
        titleDisplay.textColor = titleColor
        titleDisplay.lineBreakMode = NSLineBreakMode.ByWordWrapping
        titleDisplay.numberOfLines = 0
        // event when tap to label
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tappedLabel:")
        tapGesture.numberOfTapsRequired = 1
        titleDisplay.userInteractionEnabled =  true
        titleDisplay.addGestureRecognizer(tapGesture)
        // add element to UIView
        self.addSubview(radio)
        self.addSubview(titleDisplay)
    }
    
    /*  caculate height of title display */
    private func heightLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    /* event when tap to radio label */
    func tappedLabel(sender: UILabel)
    {
        let subperView = super.subviews
        var nameRadio: String = ""
        var currentSelected: String = ""
        for sub in subperView {
            if Mirror(reflecting: sub).subjectType == UIButton.self {
                let button = sub as! UIButton
                let titleLabel = button.titleLabel?.text
                let titleLabelArray = titleLabel?.componentsSeparatedByString(splitStr)
                nameRadio = titleLabelArray![0]
                currentSelected = titleLabelArray![1]
            }
        }
        
        for sub in (self.superview?.subviews)! {
            if Mirror(reflecting: sub).subjectType == NTPRadio.self {
                for subRadio in sub.subviews {
                    if Mirror(reflecting: subRadio).subjectType == UIButton.self {
                        let button = subRadio as! UIButton
                        let titleLabel = button.titleLabel?.text
                        let titleLabelArray = titleLabel?.componentsSeparatedByString(splitStr)
                        if nameRadio == titleLabelArray![0] as String {
                            if currentSelected == titleLabelArray![1] as String {
                                button.setBackgroundImage(checkedImage, forState: .Normal)
                                NTPRadio.data[nameRadio] = currentSelected
                            } else {
                                button.setBackgroundImage(unCheckedImage, forState: .Normal)
                            }
                        }
                    }
                }
            }
        }
    }
    
    /* event when tap to radio button */
    func tappedButton(sender: UIButton)
    {
        let dataSelected = sender.titleLabel?.text
        let dataSelectedArray = dataSelected?.componentsSeparatedByString(splitStr)
        let nameRadio = dataSelectedArray![0] as String
        let currentSelected = dataSelectedArray![1] as String
        for sub in (self.superview?.subviews)! {
            if Mirror(reflecting: sub).subjectType == NTPRadio.self {
                for subRadio in sub.subviews {
                    if Mirror(reflecting: subRadio).subjectType == UIButton.self {
                        let button = subRadio as! UIButton
                        let titleLabel = button.titleLabel?.text
                        let titleLabelArray = titleLabel?.componentsSeparatedByString(splitStr)
                        if nameRadio == titleLabelArray![0] as String {
                            if currentSelected == titleLabelArray![1] as String {
                                button.setBackgroundImage(checkedImage, forState: .Normal)
                                NTPRadio.data[nameRadio] = currentSelected
                            } else {
                                button.setBackgroundImage(unCheckedImage, forState: .Normal)
                            }
                        }
                    }
                }
            }
        }
    }
    
    /* get data radio @params: name */
    static func getSelected(name:String) -> String
    {
        if NTPRadio.data[name] != nil {
            return NTPRadio.data[name]! as String
        }
        return ""
    }
    
    /* destruct radio */
    deinit {
        NTPRadio.data.removeAll()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}