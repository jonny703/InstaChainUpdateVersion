//
//  DarkModeManager.swift
//  InstaChain
//
//  Created by John Nik on 2/5/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit

class DarkModeManager {
    
    static func getLoginPageTintColor() -> UIColor {
        if isDarkMode() {
            return StyleGuideManager.instaChainDarkBackgroundColor
        } else {
            return UIColor.white
        }
    }
    
    static func getLoginButtonTitleAlpha() -> CGFloat {
        if isDarkMode() {
            return 0.3
        } else {
            return 0.7
        }
    }
    
    static func getViewBackgroundColor() -> UIColor {
        if isDarkMode() {
            return StyleGuideManager.instaChainDarkBackgroundColor
        } else {
            return UIColor.white
        }
    }
    
    static func getDefaultTextColor() -> UIColor {
        if isDarkMode() {
            return UIColor.white
        } else {
            return UIColor.black
        }
    }
    
    static func getTableViewHeaderBackgroundColor() -> UIColor {
        if isDarkMode() {
            return UIColor.darkGray
        } else {
            return UIColor.lightGray
        }
    }
    
    static func getNavBarTintColor() -> UIColor {
        if isDarkMode() {
            return StyleGuideManager.instaChainDarkBackgroundColor
        } else {
            return StyleGuideManager.realyfeDefaultGreenColor
        }
    }
    
    static func getProfileImageBorderColor() -> UIColor {
        if isDarkMode() {
            return UIColor.white
        } else {
            return UIColor.darkGray
        }
    }
    
    static func getTextFieldBorderColor() -> UIColor {
        if isDarkMode() {
            return UIColor.white
        } else {
            return UIColor.darkGray
        }
    }
    
    static func getTextViewBackgroundColor() -> UIColor {
        if isDarkMode() {
            return UIColor.darkGray
        } else {
            return UIColor.white
        }
    }
    
    static func getSideMenuBackgroundAlpha() -> CGFloat {
        if isDarkMode() {
            return 0.25
        } else {
            return 1.0
        }
    }
    
    static func getEmptyPostImage() -> UIImage? {
        if isDarkMode() {
            return UIImage(named: AssetName.emptyPostDark.rawValue)
        } else {
            return UIImage(named: AssetName.emptyPost.rawValue)
        }
    }
    
    static func getEmptyUsersImage() -> UIImage? {
        if isDarkMode() {
            return UIImage(named: AssetName.emptyusersDark.rawValue)
        } else {
            return UIImage(named: AssetName.emptyusers.rawValue)
        }
    }
    
    static func getTagViewBackgroundColor() -> UIColor {
        if isDarkMode() {
            return UIColor.white
        } else {
            return UIColor.darkGray
        }
    }
    
    static func getTagViewTintColor() -> UIColor {
        if isDarkMode() {
            return UIColor.darkGray
        } else {
            return UIColor.white
        }
    }
    
    static func getTextViewTextColor() -> UIColor {
        if isDarkMode() {
            return StyleGuideManager.textViewDarkTextColor
        } else {
            return UIColor.lightGray
        }
    }
    
    static func getTextViewBorderColor() -> UIColor {
        if isDarkMode() {
            return UIColor.white
        } else {
            return UIColor.lightGray
        }
    }
    
    static func getImageViewTintColor() -> UIColor {
        if isDarkMode() {
            return UIColor.white
        } else {
            return UIColor.darkGray
        }
    }
    
    static func getCollectionViewBackgroundColor() -> UIColor {
        if isDarkMode() {
            return StyleGuideManager.instaChainDarkBackgroundColor
        } else {
            return UIColor.white
        }
    }
    
    static func getMenuBarBackgroundColor() -> UIColor {
        if isDarkMode() {
            return StyleGuideManager.menuBarDarkColor
        } else {
            return StyleGuideManager.realyfeDefaultGreenColor
        }
    }
    
    static func getMenuBarTitleActiveColor() -> UIColor {
        if isDarkMode() {
            return UIColor.white
        } else {
            return UIColor.black
        }
    }
    
    static func getCommentTextViewBackgroundColor() -> UIColor {
        if isDarkMode() {
            return StyleGuideManager.commentTextViewBackgroundDarkColor
        } else {
            return StyleGuideManager.commentTextViewBackgroundLightColor
        }
    }
    
    static func getKeyboardApperance() -> UIKeyboardAppearance {
        if isDarkMode() {
            return .dark
        } else {
            return .light
        }
    }
    
    static func getPhotoCameraTintColor() -> UIColor {
        if isDarkMode() {
            return .white
        } else {
            return .darkGray
        }
    }
    
    
    
    
    
    
    
    
    
    
    

}
