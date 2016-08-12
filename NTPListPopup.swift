// @package NTPListPopup.swift
// @author The Phuc
// @since 7/10/2016.

import UIKit

@objc protocol NTPListPopupDelegate : NSObjectProtocol {
    @objc optional func NTPListPopupClickedAtButtonIndex(index: String)
}

class NTPListPopup: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var SCREEN_WIDTH: CGFloat = 0.0
    var SCREEN_HEIGHT: CGFloat = 0.0
    weak var delegate: NTPListPopupDelegate?
    var NTPListPopupTableView = UITableView()
    let cellIdentifier: String = "Cell"
    
    var contentView = UIView()
    var title = String()
    var options = Array<Dictionary<String,String>>()
    var view = UIViewController()
    
    var DefaultWidth: CGFloat = 270.0
    var DefaultHeight: CGFloat = 144.0
    var DefaultHeightHeader: CGFloat = 60.0
    var DefaultHeightCell: CGFloat = 45.0
    
    var titleHeaderNTPListPopupColor: UIColor = UIColor(red: 70/255.0, green: 166/255.0, blue: 197/255.0, alpha: 1.0)
    var backgroundNTPListPopupColor: UIColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
    
    init(view: UIViewController, title: String, options: Array<Dictionary<String,String>>) {
        self.NTPListPopupTableView.separatorColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
        SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        self.title = title
        self.options = options
        self.view = view
        //Calculate
        self.DefaultHeight = DefaultHeightHeader + DefaultHeightCell * CGFloat(self.options.count)
        if self.DefaultHeight < SCREEN_HEIGHT - 100 {
            self.NTPListPopupTableView.scrollEnabled = false
        } else {
            self.NTPListPopupTableView.scrollEnabled = true
            self.DefaultHeight = SCREEN_HEIGHT - 100
        }
        //Set alpha for NTPListPopup
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        //Setup contentView
        self.contentView = UIView(frame: CGRectMake(SCREEN_WIDTH/2 - DefaultWidth/2, SCREEN_HEIGHT/2 - DefaultHeight/2, DefaultWidth, DefaultHeight))
        self.contentView.backgroundColor = backgroundNTPListPopupColor
        self.addSubview(self.contentView)
        //Set shadow for contentView
        self.contentView.layer.shadowColor = UIColor(white: 0, alpha: 0.5).CGColor
        self.contentView.layer.shadowOpacity = 1
        self.contentView.layer.shadowOffset = CGSizeZero
        self.contentView.layer.shadowRadius = 10
        self.NTPListPopupTableView.frame = self.contentView.bounds
        self.NTPListPopupTableView.delegate = self
        self.NTPListPopupTableView.dataSource = self
        self.NTPListPopupTableView.backgroundColor = UIColor.clearColor()
        self.contentView.addSubview(self.NTPListPopupTableView)
    }
    
    //MARK: - TableView Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return DefaultHeightCell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        }
        let object = self.options[indexPath.row]
        cell.textLabel?.text = object["value"]!
        cell.textLabel?.font = UIFont(name: "Arial", size: 16)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return DefaultHeightHeader
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRectMake(0, 0, self.NTPListPopupTableView.bounds.size.width, DefaultHeightHeader))
        header.backgroundColor = backgroundNTPListPopupColor
        
        let titleHeader = UILabel(frame: CGRectMake(10, 0, header.bounds.size.width - 20, header.bounds.size.height - 2))
        titleHeader.textColor = titleHeaderNTPListPopupColor
        titleHeader.text = self.title
        let tapGesture2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "close:")
        tapGesture2.numberOfTapsRequired = 1
        titleHeader.userInteractionEnabled =  true
        titleHeader.addGestureRecognizer(tapGesture2)
        header.addSubview(titleHeader)
        
        let lineHeader = UIView(frame: CGRectMake(0, header.bounds.size.height - 2, header.bounds.size.width, 2))
        lineHeader.backgroundColor = titleHeaderNTPListPopupColor
        header.addSubview(lineHeader)
        
        return header
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if (self.delegate != nil && self.delegate!.respondsToSelector(Selector("NTPListPopupClickedAtButtonIndex:"))) {
            let object = self.options[indexPath.row]
            let key:String = object["key"]! as String
            self.delegate?.NTPListPopupClickedAtButtonIndex!(key)
        }
        self.dismiss()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - NTPListPopupDelegate
    internal func setSelected(key: String){
        var row: Int = Int()
        var count: Int = 0
        for obj in self.options {
            if obj["key"] == key {
                row = count
                break
            }
            count++
        }
        NTPListPopupTableView.reloadData()
        let numberOfSections = NTPListPopupTableView.numberOfSections
        let indexPath = NSIndexPath(forRow: row, inSection: (numberOfSections-1))
        NTPListPopupTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        NTPListPopupTableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
    }
    
    internal func setNTPListPopupBackgroundColor(color: UIColor) {
        self.contentView.backgroundColor = color
    }
    
    internal func setTitleHeaderColor(color: UIColor) {
        self.titleHeaderNTPListPopupColor = color
    }
    
    internal func show() {
        self.alpha = 0
        self.view.view.addSubview(self)
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.alpha = 1
            }, completion: { (finished: Bool) in
                
        })
    }
    
    func close(recognizer: UITapGestureRecognizer){
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.alpha = 0
            }, completion: { (finished: Bool) in
                self.removeFromSuperview()
        })
    }
    
    func dismiss() {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.alpha = 0
            }, completion: { (finished: Bool) in
                self.removeFromSuperview()
        })
    }
    
    // MARK: - Orientation Change
    override func layoutSubviews() {
        SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
        SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        
        self.DefaultHeight = DefaultHeightHeader + DefaultHeightCell * CGFloat(self.options.count)
        if self.DefaultHeight < SCREEN_HEIGHT - 100 {
            self.NTPListPopupTableView.scrollEnabled = false
        } else {
            self.NTPListPopupTableView.scrollEnabled = true
            self.DefaultHeight = SCREEN_HEIGHT - 100
        }
        self.contentView.frame = CGRectMake(SCREEN_WIDTH/2 - DefaultWidth/2, SCREEN_HEIGHT/2 - DefaultHeight/2, DefaultWidth, DefaultHeight)
        
        self.contentView.frame = CGRectMake(SCREEN_WIDTH/2 - DefaultWidth/2, SCREEN_HEIGHT/2 - DefaultHeight/2, DefaultWidth, DefaultHeight)
        self.NTPListPopupTableView.frame = self.contentView.bounds
    }
}