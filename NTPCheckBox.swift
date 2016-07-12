// @package NTPCheckBox.swift
// @author The Phuc
// @since 7/10/2016.

import UIKit

class NTPCheckBox: UIView
{
    private var SCREEN_WIDTH: CGFloat = CGFloat()
    private var SCREEN_HEIGHT: CGFloat = CGFloat()
    // define image for checkBox Button
    private var checkedImage = UIImage(named: "checked_checkbox")! as UIImage
    private var unCheckedImage = UIImage(named: "unchecked_checkbox")! as UIImage
    // define element for checkBox Button
    private let checkBox: UIButton = UIButton()
    private let titleDisplay: UILabel = UILabel()
    // variable for save data when check or uncheck
    private static var data:[String:[String]] = [String:[String]]()
    private var splitStr = "####"
    private var isChecked: Bool = Bool()
    
    /* change image when tap to checkBox Button */
    private func onChange(isChecked: Bool)
    {
        if isChecked == true {
            checkBox.setBackgroundImage(checkedImage, forState: .Normal)
        } else {
            checkBox.setBackgroundImage(unCheckedImage, forState: .Normal)
        }
    }
    
    /* Init checkBox Button */
    init(frame: CGRect, name: String, text: String, value: String, checked: Bool = false, titleColor: UIColor = UIColor.blackColor())
    {
        super.init(frame: frame)
        // get screen size
        SCREEN_WIDTH = UIScreen.mainScreen().bounds.width
        SCREEN_HEIGHT = UIScreen.mainScreen().bounds.height
        // config checkBox button
        if checked {
            isChecked = true
            if NTPCheckBox.data[name]?.count != nil {
                var keepArr = NTPCheckBox.data[name]
                keepArr?.append(value)
                NTPCheckBox.data[name] = keepArr
            } else {
                NTPCheckBox.data[name] = [value]
            }
        } else {
            isChecked = false
        }
        checkBox.frame = CGRectMake(0, 0, frame.height, frame.height)
        checkBox.titleLabel?.text = name + splitStr + value
        checkBox.addTarget(self, action: "tappedButton:", forControlEvents: UIControlEvents.TouchUpInside)
        // config text display
        titleDisplay.frame = CGRectMake(frame.height + 5, 0, frame.width - frame.height - 5, frame.height)
        titleDisplay.text = text
        titleDisplay.font = UIFont(name: "Arial", size: frame.height - 5)
        titleDisplay.textColor = titleColor
        onChange(isChecked)
        // add element to UIView
        self.addSubview(checkBox)
        self.addSubview(titleDisplay)
    }
    
    /* event when tap to checkBox Button */
    func tappedButton(sender: UIButton)
    {
        let checkedData = sender.titleLabel?.text
        let checkedDataArr = checkedData?.componentsSeparatedByString(splitStr)
        let name: String = checkedDataArr![0] as String
        let value: String = checkedDataArr![1] as String
        if isChecked {
            isChecked = false
            let index = NTPCheckBox.data[name]?.indexOf(value)
            if index != nil {
                NTPCheckBox.data[name]?.removeAtIndex(index!)
            }
        } else {
            isChecked = true
            if NTPCheckBox.data[name]?.count != nil {
                var keepArr = NTPCheckBox.data[name]
                keepArr?.append(value)
                NTPCheckBox.data[name] = keepArr
            } else {
                NTPCheckBox.data[name] = [value]
            }
        }
        onChange(isChecked)
    }
    
    /* get array seleted @params: name */
    static func getAllChecked(name: String) -> [String]
    {
        if NTPCheckBox.data[name]?.count != nil {
            return NTPCheckBox.data[name]!
        }
        return [] // return empty array
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}