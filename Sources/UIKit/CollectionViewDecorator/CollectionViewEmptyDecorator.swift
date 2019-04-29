//
//  CollectionViewEmptyDecorator.swift
//  UIKitExt
//
//  Copyright (c) 2019 Javier Zhang (https://wordlessj.github.io/)
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

open class CollectionViewEmptyDecorator: CollectionViewDecorator {
    override var collectionView: UICollectionView? {
        didSet { collectionView?.register(cellType) }
    }

    private let cellType: UICollectionViewCell.Type

    private var isEmpty: Bool {
        guard let collectionView = collectionView, let dataSource = dataSource else { return true }

        if let sections = dataSource.numberOfSections?(in: collectionView), sections != 1 {
            return sections == 0
        } else {
            return dataSource.collectionView(collectionView, numberOfItemsInSection: 0) <= 0
        }
    }

    public init(cellType: UICollectionViewCell.Type) {
        self.cellType = cellType
        super.init()
    }

    open override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return isEmpty ? 1 : super.numberOfSections(in: collectionView)
    }

    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isEmpty ? 1 : super.collectionView(collectionView, numberOfItemsInSection: section)
    }

    open override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        return isEmpty ?
            collectionView.dequeue(cellType, for: indexPath) :
            super.collectionView(collectionView, cellForItemAt: indexPath)
    }
}

extension CollectionViewEmptyDecorator: UICollectionViewDelegateFlowLayout {
    open func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        return isEmpty ? .zero : layout.headerReferenceSize
    }

    open func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        return isEmpty ? .zero : layout.footerReferenceSize
    }
}
