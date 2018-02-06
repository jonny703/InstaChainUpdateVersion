//
//  extension.swift
//  InstaChain
//
//  Created by John Nik on 2/1/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import Foundation
//
//extension 
//
//extension UIButton{
//    func buttonRoundView(buttonName: UIButton, borderWidth: CGFloat, borderRadius:CGFloat,backgroundColor: UIColor, borderColor: UIColor){
//        buttonName.layer.cornerRadius = borderRadius
//        buttonName.layer.borderWidth = borderWidth
//        buttonName.backgroundColor = backgroundColor
//        buttonName.layer.borderColor = borderColor.cgColor
//    }
//}
//
//extension UIButton{
//    func halfRoundedButton(width: Int, height: Int, direction1: UIRectCorner, direction2: UIRectCorner){
//        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
//                                     byRoundingCorners: [direction1, direction2],
//                                     cornerRadii:CGSize(width: width, height: width))
//        let maskLayer1 = CAShapeLayer()
//        maskLayer1.frame = self.bounds
//        maskLayer1.path = maskPAth1.cgPath
//        self.layer.mask = maskLayer1
//
//    }
//}
//
//extension UIView{
//    func viewRoundView(viewName: UIView, borderWidth: CGFloat, borderRadius:CGFloat,backgroundColor: UIColor, borderColor: UIColor){
//        viewName.layer.cornerRadius = borderRadius
//        viewName.layer.borderWidth = borderWidth
//        viewName.backgroundColor = backgroundColor
//        viewName.layer.borderColor = borderColor.cgColor
//    }
//
//    func roundView(width: Int, height: Int, direction1: UIRectCorner, direction2: UIRectCorner ){
//        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
//                                     byRoundingCorners: [direction1 , direction2],
//                                     cornerRadii:CGSize(width: width, height: width))
//        let maskLayer1 = CAShapeLayer()
//        maskLayer1.frame = self.bounds
//        maskLayer1.path = maskPAth1.cgPath
//        self.layer.mask = maskLayer1
//
//    }
//
//}
//
//extension UIButton{
//    func buttonView(buttonname: UIButton, borderWidth: CGFloat, isClip: Bool, borderColor: UIColor, backGroundColor: UIColor){
//        buttonname.layer.backgroundColor = backGroundColor.cgColor
//        buttonname.layer.cornerRadius = buttonname.frame.height/2
//        buttonname.layer.borderWidth = borderWidth
//        buttonname.clipsToBounds = isClip
//        buttonname.layer.borderColor = borderColor.cgColor
//
//    }
//}
//
//extension UITableView{
//    func roundTableView(width: Int, height: Int, direction1: UIRectCorner, direction: UIRectCorner){
//        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
//                                     byRoundingCorners: [direction1,direction],
//                                     cornerRadii:CGSize(width: width, height: width))
//        let maskLayer1 = CAShapeLayer()
//        maskLayer1.frame = self.bounds
//        maskLayer1.path = maskPAth1.cgPath
//        self.layer.mask = maskLayer1
//
//    }
//}
//extension UIImageView{
//    func roundImageView(width: Int, height: Int, direction1: UIRectCorner, direction: UIRectCorner){
//        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
//                                     byRoundingCorners: [direction1,direction],
//                                     cornerRadii:CGSize(width: width, height: width))
//        let maskLayer1 = CAShapeLayer()
//        maskLayer1.frame = self.bounds
//        maskLayer1.path = maskPAth1.cgPath
//        self.layer.mask = maskLayer1
//        
//    }
//}
//
extension String {
    
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}
