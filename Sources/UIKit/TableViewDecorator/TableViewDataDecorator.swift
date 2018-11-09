//
//  TableViewDataDecorator.swift
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

open class TableViewDataDecorator<S>: TableViewDecorator
    where S: RandomAccessCollection,
    S.Index == Int
{
    public typealias CellForRow = (UITableView, IndexPath, S.Element) -> UITableViewCell

    open var data: S { didSet { tableView?.reloadData() } }

    private let cellForRow: CellForRow

    public init(_ data: S, cellForRow: @escaping CellForRow) {
        self.data = data
        self.cellForRow = cellForRow
    }

    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForRow(tableView, indexPath, data[indexPath.row])
    }
}

open class TableViewSectionDataDecorator<S>: TableViewDecorator
    where S: RandomAccessCollection,
    S.Index == Int,
    S.Element: RandomAccessCollection,
    S.Element.Index == Int
{
    public typealias CellForRow = (UITableView, IndexPath, S.Element.Element) -> UITableViewCell

    open var data: S { didSet { tableView?.reloadData() } }

    private let cellForRow: CellForRow

    public init(_ data: S, cellForRow: @escaping CellForRow) {
        self.data = data
        self.cellForRow = cellForRow
    }

    open func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }

    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForRow(tableView, indexPath, data[indexPath.section][indexPath.item])
    }
}

open class TableViewDataCellDecorator<S, Cell>: TableViewDataDecorator<S>
    where S: RandomAccessCollection,
    S.Index == Int,
    Cell: UITableViewCell
{
    override weak var tableView: UITableView? {
        didSet { tableView?.register(Cell.self) }
    }

    public convenience init(_ data: S, config: @escaping (Cell, IndexPath, S.Element) -> ()) {
        self.init(data, cellForRow: { tableView, indexPath, element in
            let cell = tableView.dequeue(Cell.self, for: indexPath)
            config(cell, indexPath, element)
            return cell
        })
    }
}

open class TableViewSectionDataCellDecorator<S, Cell>: TableViewSectionDataDecorator<S>
    where S: RandomAccessCollection,
    S.Index == Int,
    S.Element: RandomAccessCollection,
    S.Element.Index == Int,
    Cell: UITableViewCell
{
    override weak var tableView: UITableView? {
        didSet { tableView?.register(Cell.self) }
    }

    public convenience init(_ data: S, config: @escaping (Cell, IndexPath, S.Element.Element) -> ()) {
        self.init(data, cellForRow: { tableView, indexPath, element in
            let cell = tableView.dequeue(Cell.self, for: indexPath)
            config(cell, indexPath, element)
            return cell
        })
    }
}
