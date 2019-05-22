//
//  Measurement.swift
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

@available(iOS 10.0, *)
extension Measurement {
    public func formatted(
        minFraction: Int = 0,
        maxFraction: Int = 2,
        fraction: Int? = nil,
        unitStyle: Formatter.UnitStyle = .medium,
        config: ((MeasurementFormatter) -> Void)? = nil
    ) -> String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = unitStyle
        formatter.numberFormatter.minimumFractionDigits = minFraction
        formatter.numberFormatter.maximumFractionDigits = maxFraction

        if let fraction = fraction {
            formatter.numberFormatter.minimumFractionDigits = fraction
            formatter.numberFormatter.maximumFractionDigits = fraction
        }

        config?(formatter)
        return formatter.string(from: self)
    }
}

@available(iOS 10.0, *)
extension Unit {
    public func formatted(
        unitStyle: Formatter.UnitStyle = .medium,
        config: ((MeasurementFormatter) -> Void)? = nil
    ) -> String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = unitStyle
        config?(formatter)
        return formatter.string(from: self)
    }
}
