//
//  DirectionalButton.swift
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
open class DirectionalButton: UIButton {
    public enum Direction: Int {
        case leftToRight, rightToLeft, topToBottom, bottomToTop

        var isHorizontal: Bool {
            switch self {
            case .leftToRight, .rightToLeft: return true
            case .topToBottom, .bottomToTop: return false
            }
        }
    }

    @IBInspectable open var directionValue: Int {
        get { return direction.rawValue }
        set { direction = Direction(rawValue: newValue) ?? .leftToRight }
    }

    open var direction = Direction.leftToRight { didSet { setNeedsLayout() } }

    open override var intrinsicContentSize: CGSize {
        let titleSize = fullTitleSize(titleLabel?.intrinsicContentSize ?? .zero)
        let imageSize = fullImageSize(imageView?.intrinsicContentSize ?? .zero)

        if direction.isHorizontal {
            return CGSize(
                width: titleSize.width + imageSize.width + contentEdgeInsets.horizontal,
                height: max(titleSize.height, imageSize.height) + contentEdgeInsets.vertical
            )
        } else {
            return CGSize(
                width: max(titleSize.width, imageSize.width) + contentEdgeInsets.horizontal,
                height: titleSize.height + imageSize.height + contentEdgeInsets.vertical
            )
        }
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
        var titleRect = super.titleRect(forContentRect: contentRect)
        let inset = insets(contentRect: contentRect, titleRect: titleRect, imageRect: imageRect)

        if direction.isHorizontal {
            titleRect.origin.x = contentRect.minX + inset.width + titleEdgeInsets.left
            titleRect.origin.y = contentRect.minY + (contentRect.height - titleRect.height) / 2
        } else {
            titleRect.origin.x = contentRect.minX + titleEdgeInsets.left
            titleRect.origin.y = contentRect.minY + inset.height + titleEdgeInsets.top
            titleRect.size.width = contentRect.width - titleEdgeInsets.horizontal
        }

        switch direction {
        case .leftToRight: titleRect.origin.x += fullImageSize(imageRect.size).width
        case .topToBottom: titleRect.origin.y += fullImageSize(imageRect.size).height
        default: break
        }

        return titleRect
    }

    open override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleRect = super.titleRect(forContentRect: contentRect)
        var imageRect = super.imageRect(forContentRect: contentRect)
        let inset = insets(contentRect: contentRect, titleRect: titleRect, imageRect: imageRect)

        if direction.isHorizontal {
            imageRect.origin.x = contentRect.minX + inset.width + imageEdgeInsets.left
            imageRect.origin.y = contentRect.minY + (contentRect.height - imageRect.height) / 2
        } else {
            imageRect.origin.x = contentRect.minX + (contentRect.width - imageRect.width) / 2
            imageRect.origin.y = contentRect.minY + inset.height + imageEdgeInsets.top
        }

        switch direction {
        case .rightToLeft: imageRect.origin.x += fullTitleSize(titleRect.size).width
        case .bottomToTop: imageRect.origin.y += fullTitleSize(titleRect.size).height
        default: break
        }

        return imageRect
    }

    private func insets(contentRect: CGRect, titleRect: CGRect, imageRect: CGRect) -> CGSize {
        let titleSize = fullTitleSize(titleRect.size)
        let imageSize = fullImageSize(imageRect.size)
        return CGSize(
            width: (contentRect.width - imageSize.width - titleSize.width) / 2,
            height: (contentRect.height - imageSize.height - titleSize.height) / 2
        )
    }

    private func fullTitleSize(_ size: CGSize) -> CGSize {
        return CGSize(
            width: size.width + titleEdgeInsets.horizontal,
            height: size.height + titleEdgeInsets.vertical
        )
    }

    private func fullImageSize(_ size: CGSize) -> CGSize {
        return CGSize(
            width: size.width + imageEdgeInsets.horizontal,
            height: size.height + imageEdgeInsets.vertical
        )
    }
}
