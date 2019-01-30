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

public protocol DataDecorator: AnyObject {
    associatedtype View: CellContainer
    associatedtype Cell
    associatedtype S
    associatedtype Item
    typealias CellFor = (View, IndexPath, Item) -> Cell

    var data: S { get set }
    init(_ data: S, cellFor: @escaping CellFor, added: ((View?) -> ())?)
}

extension DataDecorator {
    public init<C: AnyObject>(_ data: S, config: @escaping (C, IndexPath, Item) -> ()) {
        self.init(data, cellFor: { collectionView, indexPath, element in
            let cell = collectionView.dequeue(C.self, for: indexPath)
            config(cell, indexPath, element)
            return cell as! Cell
        }, added: { collectionView in
            collectionView?.register(C.self)
        })
    }
}

open class CollectionViewDataDecorator<S>: CollectionViewDecorator, DataDecorator
    where S: RandomAccessCollection,
    S.Index == Int
{
    public typealias View = UICollectionView
    public typealias Cell = UICollectionViewCell
    public typealias Item = S.Element

    open var data: S { didSet { collectionView?.reloadData() } }

    override weak var collectionView: UICollectionView? {
        didSet { added?(collectionView) }
    }

    private let cellFor: CellFor
    private let added: ((UICollectionView?) -> ())?

    public required init(_ data: S, cellFor: @escaping CellFor, added: ((UICollectionView?) -> ())? = nil) {
        self.data = data
        self.cellFor = cellFor
        self.added = added
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
        return cellFor(collectionView, indexPath, data[indexPath.item])
    }
}

open class CollectionViewSectionDataDecorator<S>: CollectionViewDecorator, DataDecorator
    where S: RandomAccessCollection,
    S.Index == Int,
    S.Element: RandomAccessCollection,
    S.Element.Index == Int
{
    public typealias View = UICollectionView
    public typealias Cell = UICollectionViewCell
    public typealias Item = S.Element.Element

    open var data: S { didSet { collectionView?.reloadData() } }

    override weak var collectionView: UICollectionView? {
        didSet { added?(collectionView) }
    }

    private let cellFor: CellFor
    private let added: ((UICollectionView?) -> ())?

    public required init(_ data: S, cellFor: @escaping CellFor, added: ((UICollectionView?) -> ())? = nil) {
        self.data = data
        self.cellFor = cellFor
        self.added = added
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
        return cellFor(collectionView, indexPath, data[indexPath.section][indexPath.item])
    }
}
