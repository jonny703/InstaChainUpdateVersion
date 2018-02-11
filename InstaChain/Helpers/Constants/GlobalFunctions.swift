//
//  GlobalFunctions.swift
//  InstaChain
//
//  Created by John Nik on 2/1/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit

func isDarkMode() -> Bool {
    return UserDefaults.standard.getDarkMode()
}

func getRandomString(length: Int) -> String {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let len = UInt32(letters.length)
    
    var randomString = ""
    
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    
    return randomString
    
}

func findBestViewController(vc: UIViewController) -> UIViewController {
    
    if (vc.presentedViewController != nil) {
        return findBestViewController(vc: vc.presentedViewController!)
    } else if vc.isKind(of: UISplitViewController.self) {
        
        let svc = UISplitViewController()
        if svc.viewControllers.count > 0 {
            return findBestViewController(vc: svc.viewControllers.last!)
        } else {
            return vc
        }
        
    } else if vc.isKind(of: UINavigationController.self) {
        let nvc = UINavigationController()
        if nvc.viewControllers.count > 0 {
            return findBestViewController(vc: nvc.topViewController!)
        } else {
            return vc
        }
        
    } else if vc.isKind(of: UITabBarController.self) {
        let tvc = UITabBarController()
        if (tvc.viewControllers?.count)! > 0 {
            return findBestViewController(vc: tvc.selectedViewController!)
        } else {
            return vc
        }
    } else {
        return vc
    }
    
    
}

func currentViewController() -> UIViewController? {
    if let viewController = UIApplication.shared.keyWindow?.rootViewController {
        let returnController = findBestViewController(vc: viewController)
        return returnController
    } else {
        return nil
    }
    
}
