//
//  TableViewDecorator.swift
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

open class TableViewDecorator: NSObject {
    weak var tableView: UITableView?
    open weak var dataSource: UITableViewDataSource?
    open weak var delegate: UITableViewDelegate?

    open override func responds(to aSelector: Selector!) -> Bool {
        return super.responds(to: aSelector) ||
            (dataSource?.responds(to: aSelector) ?? false) ||
            (delegate?.responds(to: aSelector) ?? false)
    }

    open override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if (dataSource?.responds(to: aSelector) ?? false) {
            return dataSource
        } else if (delegate?.responds(to: aSelector) ?? false) {
            return delegate
        } else {
            return nil
        }
    }

    open override func doesNotRecognizeSelector(_ aSelector: Selector!) {}
}

extension TableViewDecorator: UITableViewDataSource {
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataSource?.tableView(tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.tableView(tableView, numberOfRowsInSection: section) ?? 0
    }
}

extension TableViewDecorator: UITableViewDelegate {}
