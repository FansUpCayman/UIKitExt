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

open class TableViewDataDecorator<Collection>: TableViewDecorator, DataDecorator
    where Collection: RandomAccessCollection,
    Collection.Index == Int
{
    public typealias View = UITableView
    public typealias Cell = UITableViewCell
    public typealias SectionView = UITableViewHeaderFooterView
    public typealias Section = Collection
    public typealias Item = Collection.Element

    open var data: Collection { didSet { tableView?.reloadData() } }

    override weak var tableView: UITableView? {
        didSet { added?(tableView) }
    }

    private let cellFor: CellFor
    private let headerFor: SectionViewFor?
    private let footerFor: SectionViewFor?
    private let added: ((UITableView?) -> ())?

    public required init(
        _ data: Collection,
        cellFor: @escaping CellFor,
        headerFor: SectionViewFor? = nil,
        footerFor: SectionViewFor? = nil,
        added: ((UITableView?) -> ())? = nil
    ) {
        self.data = data
        self.cellFor = cellFor
        self.headerFor = headerFor
        self.footerFor = footerFor
        self.added = added
    }

    open override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellFor(tableView, indexPath, data[indexPath.row])
    }

    open override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerFor?(tableView, IndexPath(row: 0, section: section), data) ??
            super.tableView(tableView, viewForHeaderInSection: section)
    }

    open override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerFor?(tableView, IndexPath(row: 0, section: section), data) ??
            super.tableView(tableView, viewForFooterInSection: section)
    }
}

open class TableViewSectionDataDecorator<Collection>: TableViewDecorator, DataDecorator
    where Collection: RandomAccessCollection,
    Collection.Index == Int,
    Collection.Element: RandomAccessCollection,
    Collection.Element.Index == Int
{
    public typealias View = UITableView
    public typealias Cell = UITableViewCell
    public typealias SectionView = UITableViewHeaderFooterView
    public typealias Section = Collection.Element
    public typealias Item = Collection.Element.Element

    open var data: Collection { didSet { tableView?.reloadData() } }

    override weak var tableView: UITableView? {
        didSet { added?(tableView) }
    }

    private let cellFor: CellFor
    private let headerFor: SectionViewFor?
    private let footerFor: SectionViewFor?
    private let added: ((UITableView?) -> ())?

    public required init(
        _ data: Collection,
        cellFor: @escaping CellFor,
        headerFor: SectionViewFor? = nil,
        footerFor: SectionViewFor? = nil,
        added: ((UITableView?) -> ())? = nil
    ) {
        self.data = data
        self.cellFor = cellFor
        self.headerFor = headerFor
        self.footerFor = footerFor
        self.added = added
    }

    open override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }

    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellFor(tableView, indexPath, data[indexPath.section][indexPath.item])
    }

    open override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerFor?(tableView, IndexPath(row: 0, section: section), data[section]) ??
            super.tableView(tableView, viewForHeaderInSection: section)
    }

    open override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerFor?(tableView, IndexPath(row: 0, section: section), data[section]) ??
            super.tableView(tableView, viewForFooterInSection: section)
    }
}
