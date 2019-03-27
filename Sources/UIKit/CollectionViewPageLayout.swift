//
//  CollectionViewPageLayout.swift
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

open class CollectionViewPageLayout: UICollectionViewFlowLayout {
    @IBInspectable open var isPagingEnabled: Bool = false

    open var currentIndex: Int {
        guard let collectionView = collectionView else { return 0 }
        let count = collectionView.numberOfItems(inSection: 0)
        return Int(progress.rounded()).clamped(to: 0..<count)
    }

    open var progress: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let offset: CGFloat

        switch scrollDirection {
        case .horizontal: offset = collectionView.contentOffset.x
        case .vertical: fallthrough
        @unknown default: offset = collectionView.contentOffset.y
        }

        return offset / pageSize
    }

    open var pageSize: CGFloat {
        switch scrollDirection {
        case .horizontal: return itemSize.width + minimumLineSpacing
        case .vertical: fallthrough
        @unknown default: return itemSize.height + minimumLineSpacing
        }
    }

    open override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        var size = collectionView.bounds.size
        size.width -= sectionInset.horizontal
        size.height -= sectionInset.vertical
        itemSize = size
    }

    open override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard isPagingEnabled else { return proposedContentOffset }
        var offset = proposedContentOffset

        switch scrollDirection {
        case .horizontal: offset.x = offset.x.clamped(interval: pageSize)
        case .vertical: fallthrough
        @unknown default: offset.y = offset.y.clamped(interval: pageSize)
        }

        return offset
    }

    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return collectionView.bounds.size != newBounds.size
    }
}
