//
//  LayoutConstraintUtils.swift
//  InstaChain
//
//  Created by John Nik on 2/1/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit

class LayoutConstraintUtils {
    
   static func getWidthContraint(_ view:UIView, width:CGFloat)->NSLayoutConstraint{
        
        return NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: width)
    }
    
   static func getHeightContraint(_ view:UIView, height:CGFloat)->NSLayoutConstraint{
        return NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: height)
    }
    
    static func getTopContraint(_ view:UIView, container:UIView, value:CGFloat)->NSLayoutConstraint{
        return NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.top, multiplier: 1, constant: value)
    }
    
    static func getBottomContraint(_ view:UIView, container:UIView, value:CGFloat)->NSLayoutConstraint{
        return NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: value)
    }

    static func getLeadingContraint(_ view:UIView, container:UIView, value:CGFloat)->NSLayoutConstraint{
        return NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: value)
    }

    static func getTrailingContraint(_ view:UIView, container:UIView, value:CGFloat)->NSLayoutConstraint{
        
        return NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: value)
    }
    
    static func getCenterXConstraint(_ view :UIView, container : UIView, value:CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: value)

    }
    
    static func getCenterYConstraint(_ view :UIView, container : UIView, value:CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: value)
        
    }


}


