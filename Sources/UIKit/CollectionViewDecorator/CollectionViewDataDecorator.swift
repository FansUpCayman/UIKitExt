//
//  CollectionViewDataDecorator.swift
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

open class CollectionViewDataDecorator<S>: CollectionViewDecorator
    where S: RandomAccessCollection,
    S.Index == Int
{
    public typealias CellForItem = (UICollectionView, IndexPath, S.Element) -> UICollectionViewCell

    open var data: S { didSet { collectionView?.reloadData() } }

    private let cellForItem: CellForItem

    public init(_ data: S, cellForItem: @escaping CellForItem) {
        self.data = data
        self.cellForItem = cellForItem
    }

    open override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return data.count
    }

    open override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        return cellForItem(collectionView, indexPath, data[indexPath.item])
    }
}

open class CollectionViewSectionDataDecorator<S>: CollectionViewDecorator
    where S: RandomAccessCollection,
    S.Index == Int,
    S.Element: RandomAccessCollection,
    S.Element.Index == Int
{
    public typealias CellForItem = (UICollectionView, IndexPath, S.Element.Element) -> UICollectionViewCell

    open var data: S { didSet { collectionView?.reloadData() } }

    private let cellForItem: CellForItem

    public init(_ data: S, cellForItem: @escaping CellForItem) {
        self.data = data
        self.cellForItem = cellForItem
    }

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }

    open override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return data[section].count
    }

    open override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        return cellForItem(collectionView, indexPath, data[indexPath.section][indexPath.item])
    }
}

open class CollectionViewDataCellDecorator<S, Cell>: CollectionViewDataDecorator<S>
    where S: RandomAccessCollection,
    S.Index == Int,
    Cell: UICollectionViewCell
{
    override weak var collectionView: UICollectionView? {
        didSet { collectionView?.register(Cell.self) }
    }

    public convenience init(_ data: S, config: @escaping (Cell, IndexPath, S.Element) -> ()) {
        self.init(data, cellForItem: { collectionView, indexPath, element in
            let cell = collectionView.dequeue(Cell.self, for: indexPath)
            config(cell, indexPath, element)
            return cell
        })
    }
}

open class CollectionViewSectionDataCellDecorator<S, Cell>: CollectionViewSectionDataDecorator<S>
    where S: RandomAccessCollection,
    S.Index == Int,
    S.Element: RandomAccessCollection,
    S.Element.Index == Int,
    Cell: UICollectionViewCell
{
    override weak var collectionView: UICollectionView? {
        didSet { collectionView?.register(Cell.self) }
    }

    public convenience init(_ data: S, config: @escaping (Cell, IndexPath, S.Element.Element) -> ()) {
        self.init(data, cellForItem: { collectionView, indexPath, element in
            let cell = collectionView.dequeue(Cell.self, for: indexPath)
            config(cell, indexPath, element)
            return cell
        })
    }
}
