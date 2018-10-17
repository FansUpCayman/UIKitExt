//
//  TextView.swift
//  UIKitExt
//
//  Copyright (c) 2018 Javier Zhang (https://wordlessj.github.io/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

@IBDesignable
open class TextView: UITextView {
    @IBInspectable open var placeholder: String? {
        get { return placeholderLabel.text }
        set { placeholderLabel.text = newValue }
    }

    @IBInspectable open var placeholderColor: UIColor {
        get { return placeholderLabel.textColor }
        set { placeholderLabel.textColor = newValue }
    }

    open override var contentOffset: CGPoint {
        didSet {
            guard contentOffset != .zero && contentSize.height <= bounds.height else { return }
            contentOffset = .zero
        }
    }

    open override var text: String! { didSet { updateText() } }
    open override var font: UIFont? { didSet { updateFont() } }

    private var token: NSObjectProtocol!

    private let placeholderLabel = UILabel()

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    open func commonInit() {
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0

        updateFont()
        placeholderLabel.textColor = textColor
        addSubview(placeholderLabel)

        token = NotificationCenter.default
            .addObserver(forName: UITextView.textDidChangeNotification, object: self, queue: nil) {
                [unowned self] _ in
                self.updateText()
            }
    }

    deinit {
        NotificationCenter.default.removeObserver(token)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.frame = CGRect(placeholderLabel.intrinsicContentSize)
    }

    private func updateText() {
        placeholderLabel.isHidden = !text.isEmpty
        invalidateIntrinsicContentSize()
    }

    private func updateFont() {
        placeholderLabel.font = font
    }
}
