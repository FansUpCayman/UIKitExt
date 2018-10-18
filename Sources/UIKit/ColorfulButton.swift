//
//  ColorfulButton.swift
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

@available(iOS 9.0, *)
@IBDesignable
open class ColorfulButton: UIButton {
    @IBInspectable open var color: UIColor? {
        get { return colorfulView.color }
        set { colorfulView.color = newValue }
    }

    @IBInspectable open var startColor: UIColor {
        get { return colorfulView.startColor }
        set { colorfulView.startColor = newValue }
    }

    @IBInspectable open var endColor: UIColor {
        get { return colorfulView.endColor }
        set { colorfulView.endColor = newValue }
    }

    @IBInspectable open var axisValue: Int {
        get { return colorfulView.axisValue }
        set { colorfulView.axisValue = newValue }
    }

    open var axis: ColorfulView.Axis {
        get { return colorfulView.axis }
        set { colorfulView.axis = newValue }
    }

    @IBInspectable open var cornerRadius = CGFloat.greatestFiniteMagnitude { didSet { updateCornerRadius() } }

    @IBInspectable open var borderWidth: CGFloat {
        get { return colorfulView.borderWidth }
        set { colorfulView.borderWidth = newValue }
    }

    @IBInspectable open var borderColor: UIColor? {
        get { return colorfulView.borderColor }
        set { colorfulView.borderColor = newValue }
    }

    @IBInspectable open var shadowOpacity: CGFloat {
        get { return colorfulView.shadowOpacity }
        set { colorfulView.shadowOpacity = newValue }
    }

    @IBInspectable open var shadowRadius: CGFloat {
        get { return colorfulView.shadowRadius }
        set { colorfulView.shadowRadius = newValue }
    }

    @IBInspectable open var shadowOffset: CGSize {
        get { return colorfulView.shadowOffset }
        set { colorfulView.shadowOffset = newValue }
    }

    @IBInspectable open var shadowColor: UIColor? {
        get { return colorfulView.shadowColor }
        set { colorfulView.shadowColor = newValue }
    }

    private let colorfulView = ColorfulView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    open func commonInit() {
        colorfulView.isUserInteractionEnabled = false
        colorfulView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(colorfulView, at: 0)

        colorfulView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        colorfulView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        colorfulView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        colorfulView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    open override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        sendSubviewToBack(colorfulView)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }

    private func updateCornerRadius() {
        colorfulView.cornerRadius = cornerRadius == .greatestFiniteMagnitude ?
            bounds.height / 2 : cornerRadius
    }
}
