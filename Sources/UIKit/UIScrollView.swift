//
//  UIScrollView.swift
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

extension UIScrollView {
    @available(iOS 11.0, *)
    public var adjustedContentOffset: CGPoint {
        return CGPoint(
            x: contentOffset.x + adjustedContentInset.left,
            y: contentOffset.y + adjustedContentInset.top
        )
    }

    public var startOffset: CGPoint {
        if #available(iOS 11.0, *) {
            return CGPoint(x: -adjustedContentInset.left, y: -adjustedContentInset.top)
        } else {
            return .zero
        }
    }

    public var endOffset: CGPoint {
        let start = startOffset
        let insetX: CGFloat
        let insetY: CGFloat

        if #available(iOS 11.0, *) {
            insetX = adjustedContentInset.right
            insetY = adjustedContentInset.bottom
        } else {
            insetX = 0
            insetY = 0
        }

        return CGPoint(
            x: max(contentSize.width + insetX - bounds.width, start.x),
            y: max(contentSize.height + insetY - bounds.height, start.y)
        )
    }

    public func scrollToStart(animated: Bool = false) {
        setContentOffset(startOffset, animated: animated)
    }

    public func scrollToEnd(animated: Bool = false) {
        setContentOffset(endOffset, animated: animated)
    }
}
