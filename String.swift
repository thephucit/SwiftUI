// @package String extension
// @author The Phuc
// @since 7/10/2016

import Swift

extension String {
    var parseJSONString: AnyObject? {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        if let jsonData = data {
            do {
                return try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
            } catch _ {}
        } else {
            return nil
        }
        return nil
    }
    
    func heightLabel(font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.height
    }
    
    init(htmlEncodedString: String) {
        do {
            let encodedData = htmlEncodedString.dataUsingEncoding(NSUTF8StringEncoding)!
            let attributedOptions : [String: AnyObject] = [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
            ]
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            self.init(attributedString.string)
        } catch {
            fatalError("Unhandled error: \(error)")
        }
    }
}