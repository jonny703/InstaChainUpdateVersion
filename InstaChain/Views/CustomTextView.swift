//
//  CustomTextView.swift
//  InstaChain
//
//  Created by John Nik on 1/31/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit

protocol TextViewDelegate: NSObjectProtocol {
    func textDidChange(textView: UITextView)
}

class CustomTextView: UITextView {
    
    weak var textViewDelegate: TextViewDelegate?
    
    fileprivate let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Say something about the post..."
        label.textColor = UIColor.lightGray
        return label
    }()
    
    func showPlaceholderLabel() {
        placeholderLabel.isHidden = false
    }
    
    @objc func handleTextChange() {
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setupNotification()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
        addSubview(placeholderLabel)
        _ = placeholderLabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func setupNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(textview:)), name: .UITextViewTextDidChange, object: self)
    }
    
    @objc func textDidChange(textview: UITextView) {
        self.textViewDelegate?.textDidChange(textView: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
