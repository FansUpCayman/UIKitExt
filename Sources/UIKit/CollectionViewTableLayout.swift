//
//  CollectionViewTableLayout.swift
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

@available(iOS 10.0, *)
open class CollectionViewTableLayout: UICollectionViewFlowLayout {
    @IBInspectable open var itemDimension: CGFloat = 50 { didSet { invalidateLayout() } }
    @IBInspectable open var estimatedItemDimension: CGFloat = 0 { didSet { invalidateLayout() } }
    @IBInspectable open var headerDimension: CGFloat = 0 { didSet { invalidateLayout() } }
    @IBInspectable open var footerDimension: CGFloat = 0 { didSet { invalidateLayout() } }

    open override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        let size: CGSize
        let estimatedSize: CGSize

        switch scrollDirection {
        case .horizontal:
            let height = collectionView.bounds.height - sectionInset.vertical
            size = CGSize(width: itemDimension, height: height)
            estimatedSize = CGSize(width: estimatedItemDimension, height: height)
            headerReferenceSize = CGSize(width: headerDimension, height: collectionView.bounds.height)
            footerReferenceSize = CGSize(width: footerDimension, height: collectionView.bounds.height)
        case .vertical: fallthrough
        @unknown default:
            let width = collectionView.bounds.width - sectionInset.horizontal
            size = CGSize(width: width, height: itemDimension)
            estimatedSize = CGSize(width: width, height: estimatedItemDimension)
            headerReferenceSize = CGSize(width: collectionView.bounds.width, height: headerDimension)
            footerReferenceSize = CGSize(width: collectionView.bounds.width, height: footerDimension)
        }

        itemSize = size
        estimatedItemSize = estimatedItemDimension == 0 ? .zero : estimatedSize
    }

    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        switch scrollDirection {
        case .horizontal: return collectionView.bounds.height != newBounds.height
        case .vertical: fallthrough
        @unknown default: return collectionView.bounds.width != newBounds.width
        }
    }
}

open class AutoSizeCollectionView: UICollectionView {
    open override func reloadData() {
        super.reloadData()
        // Fix crash when scrolling back after `reloadData`.
        layoutIfNeeded()
    }
}

open class AutoWidthCollectionViewCell: UICollectionViewCell {
    open override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        return systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .required
        )
    }
}

open class AutoHeightCollectionViewCell: UICollectionViewCell {
    open override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        return systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
}

@available(iOS 9.0, *)
open class NibAutoWidthCollectionViewCell: NibCollectionViewCell {
    open override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        return systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .required
        )
    }
}

@available(iOS 9.0, *)
open class NibAutoHeightCollectionViewCell: NibCollectionViewCell {
    open override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        return systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
}
