//
//  VerticalButton.swift
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
open class VerticalButton: UIButton {
    @IBInspectable open var spacing: CGFloat = 0 { didSet { invalidateIntrinsicContentSize() } }

    open override var intrinsicContentSize: CGSize {
        let titleSize = titleLabel?.intrinsicContentSize ?? .zero
        let imageSize = imageView?.intrinsicContentSize ?? .zero
        return CGSize(width: max(titleSize.width, imageSize.width),
                      height: titleSize.height + imageSize.height + spacing)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    open func commonInit() {
        titleLabel?.textAlignment = .center
    }

    open override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageRect = super.imageRect(forContentRect: contentRect)
        var rect = super.titleRect(forContentRect: contentRect)
        let top = topInset(contentRect: contentRect, imageRect: imageRect, titleRect: rect)
        rect.origin.x = 0
        rect.origin.y = top + imageRect.height + spacing
        rect.size.width = contentRect.width
        return rect
    }

    open override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleRect = super.titleRect(forContentRect: contentRect)
        var rect = super.imageRect(forContentRect: contentRect)
        rect.origin.x = (contentRect.width - rect.width) / 2
        rect.origin.y = topInset(contentRect: contentRect, imageRect: rect, titleRect: titleRect)
        return rect
    }

    private func topInset(contentRect: CGRect, imageRect: CGRect, titleRect: CGRect) -> CGFloat {
        return (contentRect.height - imageRect.height - titleRect.height - spacing) / 2
    }
}
