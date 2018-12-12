//
//  UICollectionView.swift
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

extension UICollectionView {
    public func safeScrollToItem(
        at indexPath: IndexPath,
        at scrollPosition: ScrollPosition,
        animated: Bool = false
    ) {
        guard indexPath.section < numberOfSections,
            indexPath.item < numberOfItems(inSection: indexPath.section)
            else { return }
        scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }
}

public protocol CellContainer {
    func register<Cell: AnyObject>(_ type: Cell.Type)
    func dequeue<Cell: AnyObject>(_ type: Cell.Type, for indexPath: IndexPath) -> Cell
}

extension UICollectionView: CellContainer {
    public enum ElementKind {
        case sectionHeader
        case sectionFooter
        case custom(String)

        var value: String {
            switch self {
            case .sectionHeader: return UICollectionView.elementKindSectionHeader
            case .sectionFooter: return UICollectionView.elementKindSectionFooter
            case let .custom(string): return string
            }
        }
    }

    public func register<Cell: AnyObject>(_ type: Cell.Type) {
        register(type, forCellWithReuseIdentifier: String(describing: type))
    }

    public func register<View: UICollectionReusableView>(_ type: View.Type, ofKind kind: ElementKind) {
        register(type, forSupplementaryViewOfKind: kind.value, withReuseIdentifier: String(describing: type))
    }

    public func dequeue<Cell: AnyObject>(_ type: Cell.Type, for indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withReuseIdentifier: String(describing: type), for: indexPath) as! Cell
    }

    public func dequeue<View: UICollectionReusableView>(
        _ type: View.Type,
        ofKind kind: ElementKind,
        for indexPath: IndexPath
    ) -> View {
        return dequeueReusableSupplementaryView(
            ofKind: kind.value,
            withReuseIdentifier: String(describing: type),
            for: indexPath
        ) as! View
    }
}

private let headerViewKey = AssociatedKey<UIView>()

@available(iOS 9.0, *)
extension UICollectionView {
    public var headerView: UIView? {
        get { return self[headerViewKey] }
        set { setHeaderView(newValue) }
    }

    public func setHeaderView(_ view: UIView?, insets: UIEdgeInsets = .zero) {
        contentInset.top = 0
        headerView?.removeFromSuperview()
        self[headerViewKey] = view

        guard let view = view else { return }
        let size = view.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
        contentInset.top = size.height + insets.vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        let xOffset = (insets.left - insets.right) / 2
        view.centerXAnchor.constraint(equalTo: centerXAnchor, constant: xOffset).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor, constant: -insets.horizontal).isActive = true
        view.bottomAnchor.constraint(equalTo: topAnchor, constant: -insets.bottom).isActive = true
    }
}
