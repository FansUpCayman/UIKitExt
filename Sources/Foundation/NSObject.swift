//
//  NSObject.swift
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

public struct AssociatedKey<Value> {
    let pointer = UnsafeRawPointer(UnsafeMutablePointer<UInt8>.allocate(capacity: 1))

    public init() {}
}

extension NSObject {
    public subscript<Value>(key: AssociatedKey<Value>) -> Value? {
        get { return objc_getAssociatedObject(self, key.pointer) as? Value }
        set { objc_setAssociatedObject(self, key.pointer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    public subscript<Value>(key: AssociatedKey<Value>, default defaultValue: @autoclosure () -> Value) -> Value {
        get { return self[key] ?? defaultValue() }
        set { self[key] = newValue }
    }
}
