//
//  Collection.swift
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

extension Sequence {
    public func sum<T: AdditiveArithmetic>(_ transform: (Element) throws -> T) rethrows -> T {
        return try reduce(.zero) { try $0 + transform($1) }
    }
}

extension Sequence where Element: AdditiveArithmetic {
    public func sum() -> Element {
        return sum { $0 }
    }
}

extension Collection {
    public subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension MutableCollection {
    public mutating func modify(_ action: (inout Element) throws -> Void) rethrows {
        for index in indices {
            try modify(at: index, action: action)
        }
    }

    public mutating func modify(at index: Index, action: (inout Element) throws -> Void) rethrows {
        try action(&self[index])
    }
}

extension RangeReplaceableCollection {
    public mutating func prepend(_ newElement: Element) {
        insert(newElement, at: startIndex)
    }

    public mutating func prepend<S: Collection>(contentsOf newElements: S) where Element == S.Element {
        insert(contentsOf: newElements, at: startIndex)
    }
}

extension AnyRandomAccessCollection {
    public subscript<BaseIndex: Comparable>(position: BaseIndex) -> Element {
        return self[AnyIndex(position)]
    }

    public func intIndex(_ index: Index) -> Int {
        return distance(from: startIndex, to: index)
    }
}
