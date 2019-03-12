//
//  Calendar.swift
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

extension Calendar {
    public func component(_ component: Calendar.Component, from start: Date, to end: Date) -> Int {
        return dateComponents([component], from: start, to: end)
            .value(for: component) ?? NSDateComponentUndefined
    }

    public func component(_ component: Calendar.Component, from start: DateComponents, to end: DateComponents) -> Int {
        return dateComponents([component], from: start, to: end)
            .value(for: component) ?? NSDateComponentUndefined
    }

    public func dateComponents(to component: Component, from date: Date) -> DateComponents {
        var components: [Component] = [.era, .year, .month, .day, .hour, .minute, .second, .nanosecond]

        if let index = components.firstIndex(of: component) {
            components.removeSubrange((index + 1)..<components.endIndex)
        }

        return dateComponents(Set(components), from: date)
    }

    public func interval(from start: Date, to end: Date, toGranularity component: Calendar.Component) -> Int {
        return self.component(
            component,
            from: dateComponents(to: component, from: start),
            to: dateComponents(to: component, from: end)
        )
    }

    public func dates(
        after start: Date,
        before end: Date,
        matching components: DateComponents,
        matchingPolicy: MatchingPolicy = .nextTime,
        repeatedTimePolicy: RepeatedTimePolicy = .first,
        direction: SearchDirection = .forward
    ) -> [Date] {
        var dates = [Date]()

        enumerateDates(
            startingAfter: start,
            matching: components,
            matchingPolicy: matchingPolicy,
            repeatedTimePolicy: repeatedTimePolicy,
            direction: direction
        ) { date, _, stop in
            if let date = date, date < end {
                dates.append(date)
            } else {
                stop = true
            }
        }

        return dates
    }
}
