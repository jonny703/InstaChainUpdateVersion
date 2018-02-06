//
//  MyUtils.swift
//  InstaChain
//
//  Created by John Nik on 2/1/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit


class MyUtils{
    
    
    
    static func getDatePicker(_ target: AnyObject?, selector:Selector) -> UIDatePicker{
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.addTarget(target, action: selector, for: UIControlEvents.valueChanged)
        
        return datePickerView
    }
    
    static func presentViewController(_ currentController:UIViewController, identifier: String,transition : UIModalTransitionStyle = .coverVertical, type:Int = 0) -> UIViewController?{
        if let sectionController = currentController.storyboard?.instantiateViewController(withIdentifier: identifier)
        {
            //if (transition == .CoverVertical){
            //sectionController.modalTransitionStyle = transition
            //            presentViewController(currentController, newController: sectionController)
            //            }
            //        else{
            //            //presentViewController(currentController, newController: sectionController, isShow: true)
            //            presentViewController(currentController, newController: sectionController)
            //
            //            }
            
            if type == 0 {
                presentViewControllerOnRoot(currentController, newController: sectionController)
            }
            else{
                presentViewControllerOnCurrent(currentController, newController: sectionController)
                
            }
            
            return sectionController
        }
        return nil
    }
    
    static func presentViewControllerOnCurrent(_ currentController:UIViewController, newController: UIViewController){
        // UIApplication.sharedApplication().delegate?.window!?.rootViewController?.presentViewController(newController, animated: true, completion: nil)
        currentController.present(newController, animated: true, completion: nil)
        
    }
    
    static func presentViewControllerOnRoot(_ currentController:UIViewController, newController: UIViewController){
        
        getTopMostController()?.present(newController, animated: true, completion: nil)
        //        currentController.view.window?.rootViewController?.presentViewController(newController, animated: true, completion: nil)

        // UIApplication.sharedApplication().delegate?.window!?.rootViewController?.presentViewController(newController, animated: true, completion: nil)
        //currentController.presentViewController(newController, animated: true, completion: nil)
    }
    
    
    static func getTopMostController() -> UIViewController? {
       var topController =  UIApplication.shared.keyWindow?.rootViewController
        
        while (topController?.presentedViewController != nil) {
            topController = topController!.presentedViewController;
        }
        return topController
        
    }
    
    static func presentViewController(_ currentController:UIViewController, newController: UIViewController, isShow : Bool){
        
        let rootController = currentController.view.window?.rootViewController;
        
        rootController?.view.insertSubview(newController.view, aboveSubview: currentController.view)
        newController.view.transform = CGAffineTransform(translationX: -newController.view.frame.size.width, y: 20)
        
        UIView.animate(withDuration: 0.4,
            delay: 0.0,
            options: UIViewAnimationOptions(),
            animations: {
                if (isShow) {
                    newController.view.transform = CGAffineTransform(translationX: 0, y: 20)
                }
                else{
                    
                }
            },
            completion: { finished in
                //currentController.presentViewController(newController, animated: false, completion: nil)
                currentController.view.window?.rootViewController?.present(newController, animated: false, completion: nil)
                
            }
        )
        
        
    }
    
    
    
    static func getViewControllerFromStoryBoard(_ storyBoadName : String, controllerName : String) -> UIViewController? {
        let aStoryboard =  UIStoryboard(name: storyBoadName, bundle: Bundle.main)
        
        if controllerName.isEmpty {
            return aStoryboard.instantiateInitialViewController()
        }
        else{
            return aStoryboard.instantiateViewController(withIdentifier: controllerName)
        }
    }
    
    
    static func imageResize (_ image:UIImage, sizeChange:CGSize)-> UIImage{
        
        UIGraphicsBeginImageContext(sizeChange)
        image.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return scaledImage!
    }
    
    
    static func getStatusBarHeight() -> CGFloat {
        return UIApplication().statusBarFrame.height
    }
    
    static func createShadowOnView(_ view : UIView){
        let shadowPath = UIBezierPath(rect: view.bounds)
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowPath = shadowPath.cgPath
    }
    
    static func makeNavigationBarTransparent(_ bar: UINavigationBar){
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.isTranslucent = true
        //self.navigationController.view.backgroundColor = UIColor.clearColor()
    }
    
    static func delay(_ time:Double, work:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(time)),
            execute: work)
    }
    
    static func appendKeyToJSONString(_ string:String) -> String{
        return "{\"data\":\(string)}"
        
    }
    
    
    static func makeStringTrimmed(_ inputString :String) -> String{
        return inputString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    // MARK: - border
    static func createGreyBorder(_ view :UIView?, width:CGFloat = 1){
        if view != nil {
            view!.layer.borderWidth = width
            view?.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    
    static func addDictionary <U,T>(_ lhs :inout [U:T], rhs:[U:T]) {
        for (key,value) in rhs {
            lhs[key] = value
        }
    }
    
    
    static func getViewPositionWithRespectToView(_ view : UIView, baseView: UIView? ) -> CGRect {
        var finalFrame = view.frame
        var tempView = view.superview
        while ( tempView != nil && tempView?.superview != baseView) {
            finalFrame.origin.x += (tempView?.frame.origin.x) ?? 0
            finalFrame.origin.y += tempView?.frame.origin.y ?? 0
            tempView = tempView?.superview
        }
        
        return finalFrame
    }
    
    
    
    static func setStatusBarBackgroundColor(_ color: UIColor) {
        
        guard  let statusBar = (UIApplication.shared.value(forKey: "statusBarWindow") as AnyObject).value(forKey: "statusBar") as? UIView else {
            return
        }
        
        statusBar.backgroundColor = color
    }
    
    
    static func getDeviceLanguageCode() -> String{
        
        return Locale.preferredLanguages.first ?? "en"
    }
    
    
    
    static func randomAlphaNumericString(_ length: Int) -> String {
        
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        
        for _ in 0..<length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let newCharacter = allowedChars.characters.index(allowedChars.startIndex, offsetBy: randomNum)
            randomString += String(describing: newCharacter)
        }
        
        return randomString
    }

     static func isValidEmail(email:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    static func randomNumericString(_ length: Int) -> String {
        
        let allowedChars = "0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        
        for _ in 0..<length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let newCharacter = allowedChars.characters.index(allowedChars.startIndex, offsetBy: randomNum)
            randomString += String(describing: newCharacter)
        }
        
        return randomString
    }

    static func getUUID() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
//    static func getIFAddresses() -> [String] {
//        var addresses = [String]()
//        
//        // Get list of all interfaces on the local machine:
//        var ifaddr : UnsafeMutablePointer<ifaddrs>?
//        guard getifaddrs(&ifaddr) == 0 else { return [] }
//        guard let firstAddr = ifaddr else { return [] }
//        
//        // For each interface ...
//        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
//            let flags = Int32(ptr.pointee.ifa_flags)
//            var addr = ptr.pointee.ifa_addr.pointee
//            
//            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
//            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
//                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
//                    
//                    // Convert interface address to a human readable string:
//                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
//                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
//                        let address = String(cString: hostname)
//                        addresses.append(address)
//                    }
//                }
//            }
//        }
//        
//        freeifaddrs(ifaddr)
//        return addresses
//    }

    static func getIPV4Address() -> String {
        let add = [""] // MyUtils.getIFAddresses()
        var ip = ""
        if add.count > 1 {
            ip = add[1]
        }
        else if add.count == 1 {
            ip = add[0]
        }
        return ip
    }

    static func isEmpty(string: String!) -> Bool{
        if string != nil && string.length() > 0 {
            return false
        }
        return true
    }
}
