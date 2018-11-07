//
//  UIGraphicsImageRenderer.swift
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

public enum GradientAxis: Int {
    case horizontal, vertical, diagonal, reversedDiagonal

    var points: (start: CGPoint, end: CGPoint) {
        switch self {
        case .horizontal: return (CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5))
        case .vertical: return (CGPoint(x: 0.5, y: 0), CGPoint(x: 0.5, y: 1))
        case .diagonal: return (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1))
        case .reversedDiagonal: return (CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 1))
        }
    }
}

@available(iOS 10.0, *)
extension UIGraphicsImageRenderer {
    public func fill(_ color: UIColor) -> UIImage {
        return image { context in
            color.setFill()
            context.fill(context.format.bounds)
        }
    }

    public func linearGradient(colors: [UIColor], axis: GradientAxis) -> UIImage {
        return image { context in
            let cgColors = colors.map { $0.cgColor }
            let gradient = CGGradient(colorsSpace: nil, colors: cgColors as CFArray, locations: nil)!

            let size = context.format.bounds.size
            let points = axis.points
            let start = CGPoint(x: points.start.x * size.width, y: points.start.y * size.height)
            let end = CGPoint(x: points.end.x * size.width, y: points.end.y * size.height)

            context.cgContext.drawLinearGradient(gradient, start: start, end: end, options: [])
        }
    }
}
