//
//  UIExtensions.swift
//  SwiftyUIExtension
//
//  Created by Sugam Kalra on 17/12/15.
//  Copyright © 2015 Sugam Kalra. All rights reserved.
//

import UIKit

/**
* Extension for UIView
* Some useful attributes added to UIView
*
* @author Sugam
* @version 1.0
*/
extension UIView {
    
    /// attribute for setting border width
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    /// attribute for setting border color
    var borderColor: UIColor {
        get {
            return UIColor(CGColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.CGColor
        }
    }
}

/**
* Extension for UIViewController
* Some useful functions added to UIViewController
*
* @author Sugam
* @version 1.1
*
* changes:
* 1.1:
* - OK button handler added
*/
extension UIViewController {
    /**
     Show alert
     
     - Parameters:
        - title: the title of the alert
        - message: the message of the alert
        - handler: the OK button handler
     */
    func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.Default, handler: handler))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /**
     Show error alert
        
     - Parameter message: the message of the error alert
     */
    func showErrorAlert(message: String) {
        self.showAlert("Error", message: message)
    }
    
    
    /**
     Load child controller :vc inside :contentView
     
     - parameters:
     - vc: child controller
     - contentView: container view
     */
    func loadChildController(vc: UIViewController, inContentView contentView: UIView) {
        self.addChildViewController(vc)
        contentView.addSubview(vc.view)
        vc.view.frame.size = contentView.frame.size
        vc.didMoveToParentViewController(self)
    }
    
    /**
     Unload child controller :vc from its parent
     
     - parameters:
     - vc: child controller
     */
    func unloadChildController(vc: UIViewController) {
        vc.willMoveToParentViewController(nil)
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
    }
    
    /**
     Create a view controller from storyboard.
     By default will load from the same storyboard of self storyboard.
     
     - parameters:
     - controllerClass: type of controller
     - storyboardName: the name of storyboard
     
     - returns: the controller instance from storyboard
     */
    func create<T: UIViewController>(controllerClass: T.Type, storyboardName: String? = nil) -> T? {
        let className = NSStringFromClass(controllerClass).componentsSeparatedByString(".").last!
        var storyboard = self.storyboard
        if let storyboardName = storyboardName {
            storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        }
        let controller = storyboard?.instantiateViewControllerWithIdentifier(className) as? T
        return controller
    }
    
    /**
     Class function to create a view controller from Main storyboard.
     
     - parameters:
     - controllerClass: type of the controller
     
     - returns: the controller instance from storyboard
     */
    class func createFromMainStoryboard<T: UIViewController>(controllerClass: T.Type) -> T? {
        let className = NSStringFromClass(controllerClass).componentsSeparatedByString(".").last!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier(className) as? T
        return controller
    }
    
    
    /**
     Wrap the controller in navigation Controller
     
     - parameters:
     - blurPresented: whether should be blur presented or not
     
     - returns: the navigation controller
     */
    func wrapInNavigationController() -> UINavigationController {
        var navController: UINavigationController
        navController = UINavigationController(rootViewController: self)
        navController.navigationBar.translucent = false
        navController.navigationBar.barTintColor = UIColor.whiteColor()
        navController.navigationBar.backIndicatorImage = UIImage(named: "back")
        navController.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        return navController
    }
    
    
    
    /**
     Create button for the navigation bar
     
     - parameter title:    the butotn title
     - parameter selector: the selector to invoke when tapped
     
     - returns: the view
     */
    func createBarButton(title: String, selector: Selector) -> UIView {
        // Right navigation button
        let customBarButtonView = UIView(frame: CGRectMake(0, 0, 50, 44))
        let b = UIButton()
        b.addTarget(self, action: selector, forControlEvents: UIControlEvents.TouchUpInside)
        b.frame = CGRectMake(0, -2, 60, 44);
        b.setAttributedTitle(createAttributedStringForNavigation(title), forState: UIControlState.Normal)
        
        customBarButtonView.addSubview(b)
        return customBarButtonView
    }
    
    /**
     Creates attributed string from given text.
     Returns uppercase string with a special font.
     
     - parameter text: the text
     
     - returns: NSMutableAttributedString
     */
    func createAttributedStringForNavigation(text: String) -> NSMutableAttributedString {
        let string = NSMutableAttributedString(string: text, attributes: [
            NSFontAttributeName: UIFont(name: Fonts.Light, size: 14.0)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()
            ])
        return string
    }
    
    /**
     Add left button with given icon
     
     - parameter iconName: the name of the icon
     - parameter selector: the selector to invoke when tapped
     */
    func addLeftButton(iconName iconName: String, selector: Selector) {
        let customView = createBarButton(iconName: iconName, selector: selector)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customView)
    }
    
    /**
     Add right button with given icon
     
     - parameter iconName: the name of the icon
     - parameter selector: the selector to invoke when tapped
     */
    func addRightButton(iconName iconName: String, selector: Selector) {
        let customView = createBarButton(iconName: iconName, selector: selector)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: customView)
    }
    
    
    /**
     Add right button to the navigation bar
     
     - parameter title:    the butotn title
     - parameter selector: the selector to invoke when tapped
     */
    func addRightButton(title: String, selector: Selector) {
        // Right navigation button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createBarButton(title, selector: selector))
    }

    
    /**
     Create button wthi given icon for the navigation bar
     
     - parameter iconName: the name of the icon
     - parameter selector: the selector to invoke when tapped
     
     - returns: the view
     */
    func createBarButton(iconName iconName: String, selector: Selector) -> UIView {
        let customBarButtonView = UIView(frame: CGRectMake(0, 0, 40, 30))
        // Button
        let button = UIButton()
        button.addTarget(self, action: selector, forControlEvents: UIControlEvents.TouchUpInside)
        button.frame = CGRectMake(-7.5, -1, 60.5, 30) // position like in design
        
        // Button icon
        button.setImage(UIImage(named: iconName), forState: UIControlState.Normal)
        
        // Set custom view for bar button
        customBarButtonView.addSubview(button)
        return customBarButtonView
    }


}

/**
* Extension for UIFont
* Some useful functions added to UIFont
*
* @author Sugam
* @version 1.0
*/
extension UIFont {
    /**
     Return OpenSans-Bold font with :size

     - Parameter size: the size of font
     */
    class func boldOpenSansFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Bold", size: size)!
    }
    
    
    /**
     semi bold open sans font
     
     - parameter size: font size
     */
    class func semiBoldOpenSansFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Semibold", size: size)!
    }
    
    /**
     light open sans font
     
     - parameter size: font size
     */
    class func lightOpenSansFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Light", size: size)!
    }
    
    /**
     light helvetica neue font
     
     - parameter size: font size
     */
    class func lightHelveticaNeueFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Light", size: size)!
    }

}

// the main font prefix
let FONT_PREFIX = "HelveticaNeue"

/**
* Common fonts used in the app
*
* @author Sugam
* @version 1.0
*/
struct Fonts {
    
    static var Regular = "\(FONT_PREFIX)"
    static var Bold = "\(FONT_PREFIX)-Bold"
    static var Light = "\(FONT_PREFIX)-Light"
    static var Semibold = "\(FONT_PREFIX)-Semibold"
    static var Medium = "\(FONT_PREFIX)-Medium"
    static var Italic = "\(FONT_PREFIX)-Italic"
    static var Thin = "\(FONT_PREFIX)-Thin"
}

/**
* Applies default family fonts for UILabels from IB.
*
* @author Sugam
* @version 1.0
*/
extension UILabel {
    
    /**
    Applies default family fonts
    */
    public override func awakeFromNib() {
        super.awakeFromNib()
        applyDefaultFontFamily()
    }
    
    /**
    Applies default family fonts
    
    - parameter aDecoder: the decoder
    
    - returns: UILabel instance
    */
    public override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
        self.applyDefaultFontFamily()
        return self
    }
    
    /**
    Applies default family fonts
    */
    func applyDefaultFontFamily() {
        if font.fontName.contains("Light", caseSensitive: false) {
            self.font = UIFont(name: Fonts.Light, size: self.font.pointSize)
        }
        else if font.fontName.contains("Semibold", caseSensitive: false) {
            self.font = UIFont(name: Fonts.Semibold, size: self.font.pointSize)
        }
        else if font.fontName.contains("Bold", caseSensitive: false) {
            self.font = UIFont(name: Fonts.Bold, size: self.font.pointSize)
        }
        else if font.fontName.contains("Italic", caseSensitive: false) {
            self.font = UIFont(name: Fonts.Italic, size: self.font.pointSize)
        }
        else if font.fontName.contains("Medium", caseSensitive: false) {
            self.font = UIFont(name: Fonts.Medium, size: self.font.pointSize)
        }
        else if font.fontName.contains("Regular", caseSensitive: false) {
            self.font = UIFont(name: Fonts.Regular, size: self.font.pointSize)
        }
        else if font.fontName.contains("Thin", caseSensitive: false) {
            self.font = UIFont(name: Fonts.Thin, size: self.font.pointSize)
        }
    }
}

/**
* Extends UIView with shortcut methods
*
* @author Sugam
* @version 1.0
*/
extension UIView {
    
    /**
    Add border for the view
    
    - parameter color:       the border color
    - parameter borderWidth: the size of the border
    */
    func addBorder(color: UIColor = UIColor.whiteColor(), borderWidth: CGFloat = 0.5) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color.CGColor
    }
    
    /**
    Make round corners for the view
    
    - parameter radius: the radious of the corners
    */
    func roundCorners(radius: CGFloat = 2) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    
    /// attribute for setting border width
    var borderWidthCQ: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    /// attribute for setting border color
    var borderColorCQ: UIColor {
        get {
            return UIColor(CGColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.CGColor
        }
    }
    
    /**
     Create gradient background for the view
     */
    func makeGradient() {
        self.layoutIfNeeded()
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        let color1 = UIColor.whiteLilacColor().CGColor
        let color2 = UIColor.quillGrayColor().CGColor
        let arrayColors = [color1, color2]
        gradient.colors = arrayColors
        self.layer.insertSublayer(gradient, atIndex: 0)
    }

}

/**
* Extends UIColor with color methods from design.
*
* @author Sugam
* @version 1.0
*/
extension UIColor {
    
    /**
    Creates new color with RGBA values from 0-255 for RGB and a from 0-1
    
    - parameter r: the red color
    - parameter g: the green color
    - parameter b: the blue color
    - parameter a: the alpha color
    */
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
    }
    
    /**
    Creates new color with RGBA values from 0-255 for RGB and a from 0-1
    
    - parameter g: the gray color
    - parameter a: the alpha color
    */
    convenience init(gray: CGFloat, a: CGFloat = 1) {
        self.init(r: gray, g: gray, b: gray, a: a)
    }
    
    /**
    Field background color (#959595)
    
    :returns: UIColor instance
    */
    class func fieldBackground() -> UIColor {
        return UIColor(r: 149, g: 149, b: 149, a: 0.1)
    }
    
    /**
    Field border color
    
    :returns: UIColor instance
    */
    class func fieldBorder() -> UIColor {
        return UIColor(white: 1, alpha: 0.3)
    }
    
    /**
     Get UIColor from hex string, e.g. "FF0000" -> red color
     
     - parameter hexString: the hex string
     - returns: the UIColor instance or nil
     */
    class func fromString(hexString: String) -> UIColor? {
        if hexString.characters.count == 6 {
            let redStr = hexString.substringToIndex(hexString.startIndex.advancedBy(2))
            let greenStr = hexString.substringWithRange(Range<String.Index>(
                start: hexString.startIndex.advancedBy(2),
                end: hexString.startIndex.advancedBy(4)))
            let blueStr = hexString.substringFromIndex(hexString.startIndex.advancedBy(4))
            return UIColor(
                r: CGFloat(Int(redStr, radix: 16)!),
                g: CGFloat(Int(greenStr, radix: 16)!),
                b: CGFloat(Int(blueStr, radix: 16)!))
        }
        return nil
    }
    
    /**
     light gray color 1
     */
    class func wildSandColor() -> UIColor {
        return UIColor(red:0.97, green:0.96, blue:0.96, alpha:1)
    }
    
    /**
     light gray color 2
     */
    class func seaShellColor() -> UIColor {
        return UIColor(red:0.95, green:0.94, blue:0.94, alpha:1)
    }
    
    /**
     light gray color 3
     */
    class func whiteLilacColor() -> UIColor {
        return UIColor(red:0.92, green:0.91, blue:0.91, alpha:1)
    }
    
    /**
     light gray color 4
     */
    class func quillGrayColor() -> UIColor {
        return UIColor(red:0.84, green:0.84, blue:0.84, alpha:1)
    }
    
    /**
     green color
     */
    class func christyGreenColor(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red:0.45, green:0.65, blue:0.05, alpha:alpha)
    }
    
    
    /**
     Gray color (#4d5e2c)
     
     :returns: UIColor instance
     */
    class func green() -> UIColor {
        return UIColor(r: 77, g: 94, b: 44)
    }


}

/**
* Extends UIView with shortcut methods
*
* @author Sugam
* @version 1.0
*/
extension UITextField {
    
    /**
    Get float value from the field
    
    - returns: the float value
    */
    func getFloat() -> Float? {
        return Float(self.text?.trim() ?? "")
    }
}


/**
 * Extends UIImage with a shortcut method.
 *
 * @author Sugam
 * @version 1.0
 */
extension UIImage {
    
    /**
     Load image asynchronously
     
     - parameter url:      image URL
     - parameter callback: the callback to return the image
     */
    class func loadFromURLAsync(url: NSURL, callback: (NSError?, UIImage?) -> ()) {
        
        // create the new downloading task
        NSURLSession.sharedSession().dataTaskWithURL(url) { data, response, error in
            dispatch_async(dispatch_get_main_queue()) {
                if error != nil {
                    callback(error, nil)
                    return
                }
                if let data = data {
                    if let image = UIImage(data: data) {
                        callback(nil, image)
                        return
                    }
                }
                callback(nil, nil)
            }
            }.resume()
    }
}



