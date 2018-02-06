//
//  StringLocalisationExtension.swift
//  InstaChain
//
//  Created by John Nik on 2/1/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit


extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    
    func doTrimming() -> String{
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func length() -> Int {
        return characters.count
    }

    func stringFromHtml() -> NSAttributedString? {
        do {
            let data = self.data(using: String.Encoding.utf8, allowLossyConversion: true)
            if let d = data {
                let str = try NSAttributedString(data: d,
                                                 options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                                                 documentAttributes: nil)
                
                
                return str
            }
        } catch {
        }
        return nil
    }
    
}


extension Int {
    
    func toString() -> String {
        return String(self)
    }
    
}

extension Date {
    func numberOfDaysUntilDateTime(_ toDateTime: Date, inTimeZone timeZone: TimeZone? = nil) -> Int {
        var calendar = Calendar.current
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        
        var fromDate: Date?, toDate: Date?
        
      //  (calendar as Calendar).ra
       // (calendar as Calendar).range(of: .day, start: toDate, interval: nil, for: toDateTime)
        
        let difference = (calendar as NSCalendar).components(.day, from: fromDate!, to: toDate!, options: [])
        return difference.day!
    }
}

extension UIButton {
    
    func setTitleWithoutAnimation(_ title : String, forState: UIControlState){
        UIView.performWithoutAnimation({ () -> Void in
            self.setTitle(title, for: forState)
            self.layoutIfNeeded()
            
        })
    }
}

extension UIApplication {
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIProgressView {
    
    @IBInspectable var barHeight : CGFloat {
        get {
            return transform.d * 2.0
        }
        set {
            // 2.0 Refers to the default height of 2
            let heightScale = newValue / 2.0
            let c = center
            transform = CGAffineTransform(scaleX: 1.0, y: heightScale)
            center = c
        }
    }
}


extension UIView {
    
    func addWidthContraint(_ width:CGFloat) {
        addConstraint(LayoutConstraintUtils.getWidthContraint(self, width: width))
    }
    
    func addHeightContraint(_ height:CGFloat){
        addConstraint(LayoutConstraintUtils.getHeightContraint(self, height:height))
    }
    
    func pinViewOnAllDirection(_ view :UIView){
        
        addConstraint(LayoutConstraintUtils.getBottomContraint(view, container: self, value: 0))
        addConstraint(LayoutConstraintUtils.getLeadingContraint(view, container: self, value: 0))
        addConstraint(LayoutConstraintUtils.getTopContraint(view, container: self, value: 0))
        addConstraint(LayoutConstraintUtils.getTrailingContraint(view, container: self, value: 0))
        
    }
    
    
    func pinViewOnAllDirection(_ view :UIView, left:CGFloat,top:CGFloat,right:CGFloat,bottom:CGFloat){
        
        addConstraint(LayoutConstraintUtils.getBottomContraint(view, container: self, value:bottom))
        addConstraint(LayoutConstraintUtils.getLeadingContraint(view, container: self, value: left))
        addConstraint(LayoutConstraintUtils.getTopContraint(view, container: self, value: top))
        addConstraint(LayoutConstraintUtils.getTrailingContraint(view, container: self, value: right))
        
    }
    
    func pinViewToCenter(_ view :UIView) {
        addConstraint(LayoutConstraintUtils.getCenterXConstraint(view, container: self, value: 0))
        addConstraint(LayoutConstraintUtils.getCenterYConstraint(view, container: self, value: 0))

    }
    
    func constraintWithIdentifier(_ identifier : String) -> NSLayoutConstraint?{
        
        for constraint in self.constraints{
            if (constraint.identifier == identifier) {
                return constraint
            }
        }
        return nil
    }
    
    func getViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

func += <KeyType, ValueType> (left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

//class BoxedArray<T> : MutableCollectionType,Reflectable {
//    var array :Array<T> = []
//
//    subscript (index : Int) -> T {
//        get {
//            return array[index]
//        }
//        set (newValue) {
//            array[index] = newValue
//        }
//
//    }
//
//}
