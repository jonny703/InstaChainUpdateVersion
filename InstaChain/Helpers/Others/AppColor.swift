//
//  AppColor.swift
//  InstaChain
//
//  Created by John Nik on 2/1/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit

extension UIColor {

    static func appPrimary() -> UIColor {
        return Constants.primaryColor
        //return UIColor.white
    }
    static func appSecondry() -> UIColor {
        return Constants.secondryColor
        
    }




    static func appBlue() -> UIColor {
        return UIColor(red: 127/255.0, green: 92/255.0, blue: 65/255.0, alpha: 1)
    }

    static func appRed() -> UIColor {
        return UIColor(red: 255/255.0, green: 87/255.0, blue: 34/255.0, alpha: 1)
    }

    static func appGreen() -> UIColor {
        return UIColor(red: 0/255.0, green: 150/255.0, blue: 136/255.0, alpha: 1)
    }
    static func lightBlue() -> UIColor {
        return UIColor(red: 135/255.0, green: 193/255.0, blue: 236/255.0, alpha: 1)
    }



}
