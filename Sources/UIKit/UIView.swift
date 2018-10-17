//
//  UIView.swift
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

extension UIView {
    public class func animate(
        _ shouldAnimate: Bool,
        duration: TimeInterval,
        delay: TimeInterval = 0,
        options: UIView.AnimationOptions = [],
        animations: @escaping () -> ()
    ) {
        animate(
            shouldAnimate,
            duration: duration,
            delay: delay,
            options: options,
            animations: animations,
            completion: nil
        )
    }

    public class func animate(
        _ shouldAnimate: Bool,
        duration: TimeInterval,
        delay: TimeInterval = 0,
        options: UIView.AnimationOptions = [],
        animations: @escaping () -> (),
        completion: ((Bool) -> ())?
    ) {
        if shouldAnimate {
            animate(
                withDuration: duration,
                delay: delay,
                options: options,
                animations: animations,
                completion: completion
            )
        } else {
            animations()
            completion?(true)
        }
    }

    public func snapshotImage(afterScreenUpdates afterUpdates: Bool) -> UIImage {
        let size = bounds.size
        let rect = CGRect(size)

        if #available(iOS 10.0, *) {
            return UIGraphicsImageRenderer(size: size).image { _ in
                drawHierarchy(in: rect, afterScreenUpdates: afterUpdates)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(size, isOpaque, traitCollection.displayScale)
            drawHierarchy(in: rect, afterScreenUpdates: afterUpdates)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image!
        }
    }
}
