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
    associatedtype View: RegisterDequeueable
    associatedtype Cell
    associatedtype SectionView
    associatedtype Collection
    associatedtype Section
    associatedtype Item

    typealias CellFor = (View, IndexPath, Item) -> Cell
    typealias SectionViewFor = (View, IndexPath, Section) -> SectionView

    var data: Collection { get set }

    init(
        _ data: Collection,
        cellFor: @escaping CellFor,
        headerFor: SectionViewFor?,
        footerFor: SectionViewFor?,
        added: ((View?) -> ())?
    )
}

extension DataDecorator {
    public init<C: UIView, Header: UIView, Footer: UIView>(
        _ data: Collection,
        configCell: @escaping (C, IndexPath, Item) -> (),
        configHeader: ((Header, IndexPath, Section) -> ())? = nil,
        configFooter: ((Footer, IndexPath, Section) -> ())? = nil
    ) {
        self.init(
            data,
            cellFor: { collectionView, indexPath, element in
                let cell = collectionView.dequeue(C.self, for: indexPath)
                configCell(cell, indexPath, element)
                return cell as! Cell
            },
            headerFor: configHeader.map { configHeader in
                { collectionView, indexPath, section in
                    let header = collectionView.dequeueHeader(Header.self, for: indexPath)
                    configHeader(header, indexPath, section)
                    return header as! SectionView
                }
            },
            footerFor: configFooter.map { configFooter in
                { collectionView, indexPath, section in
                    let footer = collectionView.dequeueFooter(Footer.self, for: indexPath)
                    configFooter(footer, indexPath, section)
                    return footer as! SectionView
                }
            },
            added: { collectionView in
                collectionView?.register(C.self)

                if configHeader != nil {
                    collectionView?.registerHeader(Header.self)
                }

                if configFooter != nil {
                    collectionView?.registerFooter(Footer.self)
                }
            }
        )
    }
}

open class CollectionViewDataDecorator<Collection>: CollectionViewDecorator, DataDecorator
    where Collection: RandomAccessCollection,
    Collection.Index == Int
{
    public typealias View = UICollectionView
    public typealias Cell = UICollectionViewCell
    public typealias SectionView = UICollectionReusableView
    public typealias Section = Collection
    public typealias Item = Collection.Element

    open var data: Collection { didSet { collectionView?.reloadData() } }

    override weak var collectionView: UICollectionView? {
        didSet { added?(collectionView) }
    }

    private let cellFor: CellFor
    private let headerFor: SectionViewFor?
    private let footerFor: SectionViewFor?
    private let added: ((UICollectionView?) -> ())?

    public required init(
        _ data: Collection,
        cellFor: @escaping CellFor,
        headerFor: SectionViewFor? = nil,
        footerFor: SectionViewFor? = nil,
        added: ((UICollectionView?) -> ())? = nil
    ) {
        self.data = data
        self.cellFor = cellFor
        self.headerFor = headerFor
        self.footerFor = footerFor
        self.added = added
    }

    open override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
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

    open override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let view: UICollectionReusableView?

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            view = headerFor?(collectionView, indexPath, data)
        case UICollectionView.elementKindSectionFooter:
            view = footerFor?(collectionView, indexPath, data)
        default:
            view = nil
        }

        return view ?? super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
}

open class CollectionViewSectionDataDecorator<Collection>: CollectionViewDecorator, DataDecorator
    where Collection: RandomAccessCollection,
    Collection.Index == Int,
    Collection.Element: RandomAccessCollection,
    Collection.Element.Index == Int
{
    public typealias View = UICollectionView
    public typealias Cell = UICollectionViewCell
    public typealias SectionView = UICollectionReusableView
    public typealias Section = Collection.Element
    public typealias Item = Collection.Element.Element

    open var data: Collection { didSet { collectionView?.reloadData() } }

    override weak var collectionView: UICollectionView? {
        didSet { added?(collectionView) }
    }

    private let cellFor: CellFor
    private let headerFor: SectionViewFor?
    private let footerFor: SectionViewFor?
    private let added: ((UICollectionView?) -> ())?

    public required init(
        _ data: Collection,
        cellFor: @escaping CellFor,
        headerFor: SectionViewFor? = nil,
        footerFor: SectionViewFor? = nil,
        added: ((UICollectionView?) -> ())? = nil
    ) {
        self.data = data
        self.cellFor = cellFor
        self.headerFor = headerFor
        self.footerFor = footerFor
        self.added = added
    }

    open override func numberOfSections(in collectionView: UICollectionView) -> Int {
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

    open override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let section = data[indexPath.section]
        let view: UICollectionReusableView?

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            view = headerFor?(collectionView, indexPath, section)
        case UICollectionView.elementKindSectionFooter:
            view = footerFor?(collectionView, indexPath, section)
        default:
            view = nil
        }

        return view ?? super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
}
