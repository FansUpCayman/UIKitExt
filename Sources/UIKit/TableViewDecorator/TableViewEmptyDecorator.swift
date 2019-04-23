//
//  TableViewEmptyDecorator.swift
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

open class TableViewEmptyDecorator: TableViewDecorator {
    private let cellType: UITableViewCell.Type
    private let height: CGFloat

    private var isEmpty: Bool {
        guard let tableView = tableView, let dataSource = dataSource else { return true }

        if let sections = dataSource.numberOfSections?(in: tableView), sections != 1 {
            return sections == 0
        } else {
            return dataSource.tableView(tableView, numberOfRowsInSection: 0) <= 0
        }
    }

    public init(cellType: UITableViewCell.Type, height: CGFloat) {
        self.cellType = cellType
        self.height = height
        super.init()
    }

    open override func numberOfSections(in tableView: UITableView) -> Int {
        return isEmpty ? 1 : super.numberOfSections(in: tableView)
    }

    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isEmpty ? 1 : super.tableView(tableView, numberOfRowsInSection: section)
    }

    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return isEmpty ?
            tableView.dequeue(cellType, for: indexPath) :
            super.tableView(tableView, cellForRowAt: indexPath)
    }

    open override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return isEmpty ? nil : super.tableView(tableView, viewForHeaderInSection: section)
    }

    open override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return isEmpty ? nil : super.tableView(tableView, viewForFooterInSection: section)
    }

    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isEmpty ? height : delegate?.tableView?(tableView, heightForRowAt: indexPath) ?? tableView.rowHeight
    }

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !isEmpty else { return }
        delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }

    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isEmpty ? 0 : delegate?.tableView?(tableView, heightForHeaderInSection: section) ??
            tableView.sectionHeaderHeight
    }

    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return isEmpty ? 0 : delegate?.tableView?(tableView, heightForFooterInSection: section) ??
            tableView.sectionFooterHeight
    }
}
