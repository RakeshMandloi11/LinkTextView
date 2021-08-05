//
//  LinkTextView.swift
//  TermsAndCondtion
//
//  Created by KiwiTech on 05/08/21.
//

import UIKit

class LinkTextView: UITextView, UITextViewDelegate {
    
    typealias Links = [String: String]
    
    typealias OnLinkTap = (URL) -> Bool
    
    var onLinkTap: OnLinkTap?
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        isEditable = false
        isSelectable = true
        isScrollEnabled = false //to have own size and behave like a label
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isEditable = false
        isSelectable = true
        isScrollEnabled = false //to have own size and behave like a label
        delegate = self
    }
    var allowTapOnly : Bool? {
        didSet {
            guard let isTapEnabled = self.allowTapOnly else {
                return
            }
            if isTapEnabled {
                self.allowOnlyTap()
            }
        }
    }
    func allowOnlyTap() {
        if let actualRecognizers = self.gestureRecognizers {
            for recognizer in actualRecognizers {
                recognizer.isEnabled = false
                if let longPress =  recognizer as? UITapGestureRecognizer   {
                    longPress.isEnabled = true
                }
            }
        }
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:)) || action == #selector(UIResponderStandardEditActions.paste(_:)) || action == #selector(UIResponderStandardEditActions.selectAll(_:)){
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    func addLinks(_ links: Links, linkColor: UIColor? = nil) {
        guard attributedText.length > 0  else {
            return
        }
        let mText = NSMutableAttributedString(attributedString: attributedText)
        
        for (linkText, urlString) in links {
            if linkText.count > 0 {
                let linkRange = mText.mutableString.range(of: linkText)
                mText.addAttribute(.link, value: urlString, range: linkRange)
            }
        }
        if let linkColor = linkColor {
            let linkAttributes: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor: linkColor,
                NSAttributedString.Key.underlineColor: linkColor,
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            self.linkTextAttributes = linkAttributes
        }
        attributedText = mText
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return onLinkTap?(URL) ?? true
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
         return onLinkTap?(URL) ?? true
    }

    // to disable text selection
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.selectedTextRange = nil
    }
}
