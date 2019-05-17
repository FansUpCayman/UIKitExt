//
//  IntIndexCollection.swift
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

import Foundation

public struct IntIndexCollection<Element>: RandomAccessCollection {
    public let startIndex: Int
    public let endIndex: Int

    private let elementAt: (Int) -> Element
    private let indexAfter: (Int) -> Int
    private let indexBefore: (Int) -> Int

    public init<C: RandomAccessCollection>(_ base: C) where C.Element == Element, C.Index == Int {
        startIndex = base.startIndex
        endIndex = base.endIndex
        elementAt = { base[$0] }
        indexAfter = base.index(after:)
        indexBefore = base.index(before:)
    }

    public subscript(position: Int) -> Element {
        return elementAt(position)
    }

    public func index(after i: Int) -> Int {
        return indexAfter(i)
    }

    public func index(before i: Int) -> Int {
        return indexBefore(i)
    }
}
