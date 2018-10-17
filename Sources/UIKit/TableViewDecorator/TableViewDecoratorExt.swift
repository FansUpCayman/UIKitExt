//
//  TableViewDecoratorExt.swift
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

private var decoratorsKey: UInt8 = 0

extension UITableView {
    public private(set) var decorators: [TableViewDecorator] {
        get { return associatedObject(key: &decoratorsKey) ?? [] }
        set { setAssociatedObject(key: &decoratorsKey, value: newValue) }
    }

    public func addDecorator(_ decorator: TableViewDecorator) {
        decorator.tableView = self
        decorators.append(decorator)
        setupDecorator(decorator, keyPath: \.dataSource)
        setupDecorator(decorator, keyPath: \.delegate)
    }

    private func setupDecorator<Value>(
        _ decorator: TableViewDecorator,
        keyPath: ReferenceWritableKeyPath<TableViewDecoratable, Value?>
    ) {
        var decoratable: TableViewDecoratable = self

        while let value = decoratable[keyPath: keyPath] as? TableViewDecoratable {
            decoratable = value
        }

        decorator[keyPath: keyPath] = decoratable[keyPath: keyPath]
        decoratable[keyPath: keyPath] = decorator as? Value
    }
}
