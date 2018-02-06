//
//  StyleGuideManager.swift
//  InstaChain
//
//  Created by John Nik on 2/1/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit

public class StyleGuideManager {
    private init(){}
    
    static let sharedInstance : StyleGuideManager = {
        let instance = StyleGuideManager()
        return instance
    }()
    
    //default
    static let realyfeDefaultGreenColor = UIColor(r: 63, g: 197, b: 206)
    static let realyfeDefaultBlueColor = UIColor(r: 19, g: 163, b: 207)
    
    static let instaChainDarkBackgroundColor = UIColor(r: 25, g: 25, b: 27)
    static let instaChainLightBackgroundColor = UIColor.white
    static let textViewDarkTextColor = UIColor(r: 67, g: 66, b: 72)
    static let textViewPlaceholderColor = UIColor(r: 99, g: 98, b: 204)
    static let menuBarDarkColor = UIColor(r: 42, g: 42, b: 44)
    static let commentTextViewBackgroundDarkColor = UIColor(r: 44, g: 44, b: 52)
    static let commentTextViewBackgroundLightColor = UIColor(r: 240, g: 241, b: 243)
    //intro
    static let signinButtonColor = UIColor(r: 19, g: 163, b: 207)
    static let currentPageIndicatorTintColor = UIColor(r: 247, g: 154, b: 27)
    static let currentPageIndicatorGreenTintColor = UIColor(r: 19, g: 163, b: 207)
    static let defaultGreenTintColor = UIColor(r: 132, g: 152, b: 66)
    
    //intro textcolor
    static let firstTextColor = UIColor(r: 95, g: 123, b: 255)
    static let secondTextColor = UIColor(r: 181, g: 95, b: 255)
    static let thirdTextColor = UIColor(r: 255, g: 95, b: 164)
    
    //button colors
    static let signinButtonBackgroundColor = UIColor(r: 19, g: 163, b: 207)
    
    //status bar colors
    static let loginStatusBarColor = UIColor(r: 215, g: 214, b: 213)
    static let signupStatusBarColor = UIColor(r: 65, g: 65, b: 65)
    
    func loginFontLarge() -> UIFont {
        return UIFont(name: "Helvetica Light", size: 30)!
        
    }
}

