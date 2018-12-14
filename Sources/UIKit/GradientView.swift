//
//  GradientView.swift
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

open class GradientView: UIView {
    open var colors: [UIColor]? {
        get { return gradientLayer.colors?.map { UIColor(cgColor: $0 as! CGColor) } }
        set { gradientLayer.colors = newValue?.map { $0.cgColor } }
    }

    open var locations: [CGFloat]? {
        get { return gradientLayer.locations?.map { CGFloat($0.doubleValue) } }
        set { gradientLayer.locations = newValue?.map { NSNumber(value: Double($0)) } }
    }

    open var endPoint = CGPoint(x: 0.5, y: 1) { didSet { updateEndPoint() } }

    open var startPoint: CGPoint {
        get { return gradientLayer.startPoint }
        set {
            gradientLayer.startPoint = newValue
            updateEndPoint()
        }
    }

    open var type: CAGradientLayerType {
        get { return gradientLayer.type }
        set { gradientLayer.type = newValue }
    }

    open override class var layerClass: AnyClass { return CAGradientLayer.self }

    private var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }

    open override func layoutSubviews() {
        super.layoutSubviews()
        updateEndPoint()
    }

    // https://stackoverflow.com/questions/38821631/cagradientlayer-diagonal-gradient
    private func updateEndPoint() {
        let width = bounds.width
        let height = bounds.height
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y

        if width == 0 || height == 0 || width == height || dx == 0 || dy == 0 {
            gradientLayer.endPoint = endPoint
        } else {
            let ux = dx * width / height
            let uy = dy * height / width
            let coef = (dx * ux + dy * uy) / (ux * ux + uy * uy)
            gradientLayer.endPoint = CGPoint(x: startPoint.x + coef * ux, y: startPoint.y + coef * uy)
        }
    }
}
