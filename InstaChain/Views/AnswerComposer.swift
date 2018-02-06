//
//  AnswerComposer.swift
//  InstaChain
//
//  Created by John Nik on 1/31/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit
import PureLayout

/// Constant to help text padding. Helps to do not overlap emojis.
let GlyphLinePadding: CGFloat = 3.0

/// Distance between the bottom of the view and the TextView
let TextViewBottomInset: CGFloat = 10.0

/// Distance between the top of the view and the TextView
let TextViewTopInset: CGFloat = 10.0

/// The maximum number of lines for the text view.
let MaxNumberOfLines: Int = 5

protocol AnswerComposerDelegate: NSObjectProtocol {
    
}

class AnswerComposer: UIView {
    
    //MARK: - Accessors
    var delegate: CommentInputAccessoryViewDelegate?
    
    var inputAccessoryViewHeight: NSLayoutConstraint?
    
    lazy var separatorView: UIView = {
        
        var separatorView = UIView()
        
        separatorView.backgroundColor = UIColor.lightGray
        
        return separatorView
    }()
    
    lazy var textView: CustomTextView = {
        
        let textView = CustomTextView.newAutoLayout()
        
        textView.textColor = UIColor.darkGray
        textView.showsVerticalScrollIndicator = false
        textView.font = UIFont.systemFont(ofSize: 18.0)
        textView.tintColor = UIColor.darkGray
        textView.delegate = self
        
        textView.backgroundColor = UIColor.white
        
//        textView.textContainerInset = UIEdgeInsetsMake(GlyphLinePadding,
//                                                       0.0,
//                                                       2.0,
//                                                       0.0)
        
//        textView.layer.cornerRadius = 5.0
//        textView.layer.borderColor = UIColor.darkGray.cgColor
//        textView.layer.borderWidth = 0.5
        
        textView.layoutManager.delegate = self;
        
        // Disabling textView scrolling prevents some undesired effects,
        // like incorrect contentOffset when adding new line,
        // and makes the textView behave similar to Apple's Messages app
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    lazy var sendButton: UIButton = {
        
        let sendButton = UIButton.newAutoLayout()
        
        sendButton.setTitle("Send",
                            for: .normal)
        
        sendButton.addTarget(self, action: #selector(sendButtonPressed(sender:)), for: .touchUpInside)
        
        sendButton.setTitleColor(UIColor.black,
                                 for: .normal)
        
        sendButton.titleLabel!.font = UIFont.systemFont(ofSize: 18.0)
        
        sendButton.backgroundColor = UIColor.white
        
//        sendButton.layer.cornerRadius = 5.0
//        sendButton.layer.borderColor = UIColor.darkGray.cgColor
//        sendButton.layer.borderWidth = 0.5
        
        return sendButton
    }()
    
    //MARK: - Init
    
    convenience init() {
        
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        addSubview(sendButton)
        addSubview(textView)
        addSubview(separatorView)
        
        // Important to clip the view to the inputAccessoryView
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func clearCommentTextField() {
        textView.text = nil
        textView.showPlaceholderLabel()
    }
    
    //MARK: - ButtonActions
    
    @objc func sendButtonPressed(sender: UIButton) {
        
        textView.resignFirstResponder()
        
        guard let comment = textView.text, comment.count > 0 else { return }
        textView.text = ""
        delegate?.didSubmit(for: comment)
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        
        separatorView.autoPinEdge(toSuperviewEdge: .top)
        
        separatorView.autoPinEdge(toSuperviewEdge: .right)
        
        separatorView.autoPinEdge(toSuperviewEdge: .left)
        
        separatorView.autoSetDimension(.height,
                                       toSize: 1.0)
        
        /*-----------------------*/
        
        textView.autoPinEdge(toSuperviewEdge: .bottom,
                             withInset: TextViewBottomInset)
        
        textView.autoPinEdge(toSuperviewEdge: .left,
                             withInset: 14.0)
        
        textView.autoPinEdge(toSuperviewEdge: .right,
                             withInset: 68.0)
        
        /*-----------------------*/
        
        sendButton.autoSetDimension(.width,
                                    toSize: 60.0)
        
        sendButton.autoSetDimension(.height,
                                    toSize: 30.0)
        
        sendButton.autoPinEdge(toSuperviewEdge: .right,
                               withInset: 10.0)
        
        sendButton.autoPinEdge(toSuperviewEdge: .bottom,
                               withInset: TextViewBottomInset + 5)
        
        /*-----------------------*/
        
        // Search and store the inputAccessoryView Height constraint.
        if inputAccessoryViewHeight == nil {
            
            for constraint in self.constraints {
                
                if constraint.firstAttribute == .height {
                    
                    inputAccessoryViewHeight = constraint
                }
            }
        }
        
        /*-----------------------*/
        
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let numberLines: Int = Int((intrinsicContentSize().height / (textView.font!.lineHeight + GlyphLinePadding)))
        
        var newInputAccessoryViewHeight: CGFloat = 0.0
        
        // Fix the inputAccessoryView Height if it is over 5 lines.
        if numberLines > MaxNumberOfLines {
            
            newInputAccessoryViewHeight = ((textView.font!.lineHeight + GlyphLinePadding) * CGFloat(MaxNumberOfLines)) + 5.5
        }
        else {
            
            newInputAccessoryViewHeight = intrinsicContentSize().height
        }
        
        inputAccessoryViewHeight?.constant = newInputAccessoryViewHeight + TextViewBottomInset + TextViewTopInset
    }
    
    func intrinsicContentSize() -> CGSize {
        
        // Calculate CGSize that will fit all the text
        let size = CGSize(width: textView.bounds.width,
                          height: CGFloat.greatestFiniteMagnitude)
        
        let textSize = textView.sizeThatFits(size)
        
        return CGSize(width: UIViewNoIntrinsicMetric,
                      height: textSize.height)
    }
    
    
}

extension AnswerComposer: UITextViewDelegate {
    
    //MARK: UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        invalidateIntrinsicContentSize()
    }
}

extension AnswerComposer: NSLayoutManagerDelegate {
    
    //MARK: NSLayoutManagerDelegate
    
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return GlyphLinePadding
    }
}
