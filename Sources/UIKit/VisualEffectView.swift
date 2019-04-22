//
//  VisualEffectView.swift
//  UIKitExt
//
//  Copyright (c) 2019 Javier Zhang (https://wordlessj.github.io/)
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
open class VisualEffectView: UIVisualEffectView {
    @IBInspectable open var blurRadius: CGFloat {
        get { return effectValue(forKey: blurRadiusKey) as? CGFloat ?? 0 }
        set { setEffectValue(newValue, forKey: blurRadiusKey) }
    }

    @IBInspectable open var colorTint: UIColor? {
        get { return effectValue(forKey: colorTintKey) as? UIColor }
        set { setEffectValue(newValue, forKey: colorTintKey) }
    }

    @IBInspectable open var colorTintAlpha: CGFloat {
        get { return effectValue(forKey: colorTintAlphaKey) as? CGFloat ?? 0 }
        set { setEffectValue(newValue, forKey: colorTintAlphaKey) }
    }

    @IBInspectable open var scale: CGFloat {
        get { return effectValue(forKey: scaleKey) as? CGFloat ?? 0 }
        set { setEffectValue(newValue, forKey: scaleKey) }
    }

    private let blurRadiusKey = "blurRadius"
    private let colorTintKey = "colorTint"
    private let colorTintAlphaKey = "colorTintAlpha"
    private let scaleKey = "scale"

    private let blurEffect = (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()

    public override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        scale = 1
    }

    private func effectValue(forKey key: String) -> Any? {
        return blurEffect.value(forKeyPath: key)
    }

    private func setEffectValue(_ value: Any?, forKey key: String) {
        blurEffect.setValue(value, forKeyPath: key)
        effect = blurEffect
    }
}
