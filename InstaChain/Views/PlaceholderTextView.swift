//
//  PlaceholderTextView.swift
//  InstaChain
//
//  Created by John Nik on 1/31/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit

class PlaceholderTextView: UITextView {
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Say something about you..."
        label.textColor = UIColor.lightGray
        return label
    }()
    
    func showPlaceholderLabel() {
        placeholderLabel.isHidden = false
    }
    
    func hidePlaceholderLabel() {
        placeholderLabel.isHidden = true
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
        addSubview(placeholderLabel)
        _ = placeholderLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
    }
    
    @objc func handleTextChange() {
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
