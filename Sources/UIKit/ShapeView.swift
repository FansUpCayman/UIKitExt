//
//  ShapeView.swift
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

open class ShapeView: UIView {
    open var path: CGPath? {
        get { return shapeLayer.path }
        set { shapeLayer.path = newValue }
    }

    open var fillColor: UIColor? {
        get { return shapeLayer.fillColor.map { UIColor(cgColor: $0) } }
        set { shapeLayer.fillColor = newValue?.cgColor }
    }

    open var fillRule: CAShapeLayerFillRule {
        get { return shapeLayer.fillRule }
        set { shapeLayer.fillRule = newValue }
    }

    open var lineCap: CAShapeLayerLineCap {
        get { return shapeLayer.lineCap }
        set { shapeLayer.lineCap = newValue }
    }

    open var lineDashPattern: [CGFloat]? {
        get { return shapeLayer.lineDashPattern?.map { CGFloat($0.doubleValue) } }
        set { shapeLayer.lineDashPattern = newValue?.map { NSNumber(value: Double($0)) } }
    }

    open var lineDashPhase: CGFloat {
        get { return shapeLayer.lineDashPhase }
        set { shapeLayer.lineDashPhase = newValue }
    }

    open var lineJoin: CAShapeLayerLineJoin {
        get { return shapeLayer.lineJoin }
        set { shapeLayer.lineJoin = newValue }
    }

    open var lineWidth: CGFloat {
        get { return shapeLayer.lineWidth }
        set { shapeLayer.lineWidth = newValue }
    }

    open var miterLimit: CGFloat {
        get { return shapeLayer.miterLimit }
        set { shapeLayer.miterLimit = newValue }
    }

    open var strokeColor: UIColor? {
        get { return shapeLayer.strokeColor.map { UIColor(cgColor: $0) } }
        set { shapeLayer.strokeColor = newValue?.cgColor }
    }

    open var strokeStart: CGFloat {
        get { return shapeLayer.strokeStart }
        set { shapeLayer.strokeStart = newValue }
    }

    open var strokeEnd: CGFloat {
        get { return shapeLayer.strokeEnd }
        set { shapeLayer.strokeEnd = newValue }
    }

    open override class var layerClass: AnyClass { return CAShapeLayer.self }

    private var shapeLayer: CAShapeLayer { return layer as! CAShapeLayer }
}
