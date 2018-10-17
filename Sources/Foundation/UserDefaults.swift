//
//  UserDefaults.swift
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

import Foundation

extension UserDefaults {
    public func optionalBool(forKey defaultName: String) -> Bool? {
        return optionalValue(forKey: defaultName, value: bool)
    }

    public func optionalInteger(forKey defaultName: String) -> Int? {
        return optionalValue(forKey: defaultName, value: integer)
    }

    public func optionalFloat(forKey defaultName: String) -> Float? {
        return optionalValue(forKey: defaultName, value: float)
    }

    public func optionalDouble(forKey defaultName: String) -> Double? {
        return optionalValue(forKey: defaultName, value: double)
    }

    private func optionalValue<Value>(forKey defaultName: String, value: (String) -> Value) -> Value? {
        return object(forKey: defaultName).map { _ in value(defaultName) }
    }
}
