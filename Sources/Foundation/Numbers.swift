//
//  Numbers.swift
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

extension ExpressibleByIntegerLiteral {
    public init(_ value: Bool) {
        self = value ? 1 : 0
    }
}

extension Numeric {
    public var isSingular: Bool { return self == 1 }
}

extension FloatingPoint {
    public func divided(by other: Self, default defaultValue: Self = 0) -> Self {
        return other != 0 ? self / other : defaultValue
    }
}

public protocol DoubleConvertible {
    var toDouble: Double { get }
    init(_ value: Double)
}

@available(iOS 10.0, *)
extension DoubleConvertible {
    public var minutes: Self { return converted(from: UnitDuration.minutes, to: .seconds) }
    public var hours: Self { return converted(from: UnitDuration.hours, to: .seconds) }

    public var toMinutes: Self { return converted(from: UnitDuration.seconds, to: .minutes) }
    public var toHours: Self { return converted(from: UnitDuration.seconds, to: .hours) }

    public func converted<D: Dimension>(from: D, to: D) -> Self {
        return Self(Measurement(value: toDouble, unit: from).converted(to: to).value)
    }
}

extension Int: DoubleConvertible {
    public var toDouble: Double { return Double(self) }
}

extension Double: DoubleConvertible {
    public var toDouble: Double { return self }
}

private let intFormatter = NumberFormatter()

extension Int {
    public func formatted() -> String {
        return intFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

extension Int64 {
    public func formatted() -> String {
        return intFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

private let doubleFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.minimumIntegerDigits = 1
    return formatter
}()

private let durationFormatter = DateComponentsFormatter()

extension Double {
    public func formatted(fraction: Int = 2) -> String {
        doubleFormatter.minimumFractionDigits = fraction
        doubleFormatter.maximumFractionDigits = fraction
        return doubleFormatter.string(from: NSNumber(value: self)) ?? ""
    }

    public func formattedDuration(
        units: NSCalendar.Unit,
        maxUnitCount: Int = 0,
        zeroPad: Bool = false,
        unitsStyle: DateComponentsFormatter.UnitsStyle = .positional
    ) -> String {
        durationFormatter.allowedUnits = units
        durationFormatter.maximumUnitCount = maxUnitCount
        durationFormatter.zeroFormattingBehavior = zeroPad ? .pad : .default
        durationFormatter.unitsStyle = unitsStyle
        return durationFormatter.string(from: self) ?? ""
    }
}
