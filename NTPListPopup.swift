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
    
    var contentView = UIView()
    var NTPListPopupTableView = UITableView()
    var prefix:String = String()
    var status:Bool = Bool()
    
    var title = String()
    var options = NSDictionary()
    var arrKeyString = [String]()
    var arrKeyInt = [Int]()
    var arrValueString = [String]()
    var arrValueInt = [Int]()
    var view = UIViewController()
    
    var DefaultWidth: CGFloat = 270.0
    var DefaultHeight: CGFloat = 144.0
    var DefaultHeightHeader: CGFloat = 60.0
    var DefaultHeightCell: CGFloat = 45.0
    
    var titleHeaderNTPListPopupColor: UIColor = UIColor(red: 70/255.0, green: 166/255.0, blue: 197/255.0, alpha: 1.0)
    var backgroundNTPListPopupColor: UIColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
    
    init(view: UIViewController, title: String, options: NSDictionary, status: Bool = false) {
        SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
        SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        prefix = ""
        
        self.title = title
        self.options = options
        self.view = view
        self.status = status
        for(key, value) in options {
            if self.status {
                arrValueInt.append(value as! Int)
                arrValueInt.sortInPlace({$0 < $1 })
                arrKeyInt.append(key as! Int)
                arrKeyInt.sortInPlace({$0 < $1 })
            } else {
                arrKeyString.append(key as! String)
                arrValueString.append(value as! String)
            }
        }
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
        let cellIdentifier = "Cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell!
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        }
        if self.status {
            cell.textLabel?.text = prefix + String(self.arrValueInt[indexPath.row])
        } else {
            cell.textLabel?.text = prefix + self.arrValueString[indexPath.row]
        }
        cell.textLabel?.font = UIFont(name: "Arial", size: SCREEN_WIDTH / 30)
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
        header.addSubview(titleHeader)
        
        let lineHeader = UIView(frame: CGRectMake(0, header.bounds.size.height - 2, header.bounds.size.width, 2))
        lineHeader.backgroundColor = titleHeaderNTPListPopupColor
        header.addSubview(lineHeader)
        
        return header
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if (self.delegate != nil && self.delegate!.respondsToSelector(Selector("NTPListPopupClickedAtButtonIndex:"))) {
            if self.status {
                self.delegate?.NTPListPopupClickedAtButtonIndex!(String(self.arrKeyInt[indexPath.row]))
            } else {
                self.delegate?.NTPListPopupClickedAtButtonIndex!(self.arrKeyString[indexPath.row])
            }
        }
        self.dismiss()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - NTPListPopupDelegate
    
    internal func setMyPrefix(prefix: String){
        self.prefix = prefix
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