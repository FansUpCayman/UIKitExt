//
//  ColorfulView.swift
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
open class ColorfulView: UIView {
    public enum Axis: Int {
        case horizontal, vertical, diagonal, reversedDiagonal
    }

    public enum MaskType {
        case fill, stroke(CGFloat, CAShapeLayerLineCap)
    }

    @IBInspectable open var color: UIColor? {
        get { return gradientView.backgroundColor }
        set { gradientView.backgroundColor = newValue }
    }

    @IBInspectable open var startColor: UIColor = .clear { didSet { updateColors() } }
    @IBInspectable open var endColor: UIColor = .clear { didSet { updateColors() } }

    @IBInspectable open var axisValue: Int {
        get { return axis.rawValue }
        set { axis = Axis(rawValue: newValue) ?? .vertical }
    }

    open var axis = Axis.vertical { didSet { updateAxis() } }

    @IBInspectable open var cornerRadius: CGFloat {
        get { return gradientView.layer.cornerRadius }
        set { gradientView.layer.cornerRadius = newValue }
    }

    @available(iOS 11.0, *)
    @IBInspectable open var maskedCornersValue: UInt {
        get { return maskedCorners.rawValue }
        set { maskedCorners = CACornerMask(rawValue: newValue) }
    }

    @available(iOS 11.0, *)
    open var maskedCorners: CACornerMask {
        get { return gradientView.layer.maskedCorners }
        set { gradientView.layer.maskedCorners = newValue }
    }

    @IBInspectable open var borderWidth: CGFloat {
        get { return gradientView.layer.borderWidth }
        set { gradientView.layer.borderWidth = newValue }
    }

    @IBInspectable open var borderColor: UIColor? {
        get { return gradientView.layer.borderColor.map { UIColor(cgColor: $0) } }
        set { gradientView.layer.borderColor = newValue?.cgColor }
    }

    @IBInspectable open var shadowOpacity: CGFloat {
        get { return CGFloat(gradientView.layer.shadowOpacity) }
        set { gradientView.layer.shadowOpacity = Float(newValue) }
    }

    @IBInspectable open var shadowRadius: CGFloat {
        get { return gradientView.layer.shadowRadius }
        set { gradientView.layer.shadowRadius = newValue }
    }

    @IBInspectable open var shadowOffset: CGSize {
        get { return gradientView.layer.shadowOffset }
        set { gradientView.layer.shadowOffset = newValue }
    }

    @IBInspectable open var shadowColor: UIColor? {
        get { return gradientView.layer.shadowColor.map { UIColor(cgColor: $0) } }
        set { gradientView.layer.shadowColor = newValue?.cgColor }
    }

    open var maskType = MaskType.fill { didSet { updateMaskType() } }
    open var maskPath: CGPath? { didSet { updateMaskPath() } }
    open var maskStrokeEnd: CGFloat = 1 { didSet { updateMaskStrokeEnd() } }

    private let gradientView = GradientView()

    open var shapeMask: ShapeView? {
        return gradientView.mask as? ShapeView
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
        insertSubview(gradientView, at: 0)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        gradientView.frame = bounds
        layoutMask()
    }

    private func updateColors() {
        gradientView.colors = [startColor, endColor]
    }

    private func updateAxis() {
        switch axis {
        case .horizontal:
            gradientView.startPoint = CGPoint(x: 0, y: 0.5)
            gradientView.endPoint = CGPoint(x: 1, y: 0.5)
        case .vertical:
            gradientView.startPoint = CGPoint(x: 0.5, y: 0)
            gradientView.endPoint = CGPoint(x: 0.5, y: 1)
        case .diagonal:
            gradientView.startPoint = CGPoint(x: 0, y: 0)
            gradientView.endPoint = CGPoint(x: 1, y: 1)
        case .reversedDiagonal:
            gradientView.startPoint = CGPoint(x: 1, y: 0)
            gradientView.endPoint = CGPoint(x: 0, y: 1)
        }
    }

    private func updateMaskType() {
        guard let mask = shapeMask else { return }
        let color = UIColor.white

        switch maskType {
        case .fill:
            mask.fillColor = color
            mask.strokeColor = nil
        case let .stroke(width, lineCap):
            mask.fillColor = nil
            mask.strokeColor = color
            mask.lineCap = lineCap
            mask.lineWidth = width
        }

        layoutMask()
    }

    private func updateMaskPath() {
        if let path = maskPath {
            if gradientView.mask == nil {
                gradientView.mask = ShapeView()
                updateMaskType()
                updateMaskStrokeEnd()
            }

            shapeMask?.path = path
        } else {
            gradientView.mask = nil
        }

        layoutMask()
    }

    private func updateMaskStrokeEnd() {
        shapeMask?.strokeEnd = maskStrokeEnd
    }

    private func layoutMask() {
        guard let mask = shapeMask else { return }
        switch maskType {
        case .fill:
            mask.frame = gradientView.bounds
        case let .stroke(width, _):
            let inset = width / 2
            gradientView.frame = bounds.insetBy(dx: -inset, dy: -inset)
            mask.frame = bounds.offsetBy(dx: inset, dy: inset)
        }
    }
}
