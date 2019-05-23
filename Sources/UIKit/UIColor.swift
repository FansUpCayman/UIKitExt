//
//  UIColor.swift
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

extension UIColor {
    public enum Profile {
        case sRGB, displayP3
    }

    public struct RGBA {
        public var red: CGFloat = 0
        public var green: CGFloat = 0
        public var blue: CGFloat = 0
        public var alpha: CGFloat = 1

        public init() {}

        public init(_ hex: Int, alpha: CGFloat) {
            red = CGFloat(hex / 0x10000 % 0x100) / 0xff
            green = CGFloat(hex / 0x100 % 0x100) / 0xff
            blue = CGFloat(hex % 0x100) / 0xff
            self.alpha = alpha
        }
    }

    public static var defaultProfile = Profile.sRGB

    public var rgba: RGBA {
        var r = RGBA()
        getRed(&r.red, green: &r.green, blue: &r.blue, alpha: &r.alpha)
        return r
    }

    public convenience init(rgba: RGBA, profile: Profile? = nil) {
        switch profile ?? UIColor.defaultProfile {
        case .sRGB: self.init(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: rgba.alpha)
        case .displayP3:
            if #available(iOS 10.0, *) {
                self.init(displayP3Red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: rgba.alpha)
            } else {
                self.init(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: rgba.alpha)
            }
        }
    }

    public convenience init(_ hex: Int, alpha: CGFloat = 1, profile: Profile? = nil) {
        self.init(rgba: RGBA(hex, alpha: alpha), profile: profile)
    }
}
