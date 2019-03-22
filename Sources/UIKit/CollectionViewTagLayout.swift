//
//  CollectionViewTagLayout.swift
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

open class CollectionViewTagLayout: UICollectionViewFlowLayout {
    public enum Alignment: Int {
        case left, center, right
    }

    open var alignment = Alignment.left { didSet { invalidateLayout() } }

    @IBInspectable open var alignmentValue: Int {
        get { return alignment.rawValue }
        set { alignment = Alignment(rawValue: newValue) ?? .left }
    }

    public override init() {
        super.init()
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    open func commonInit() {
        if #available(iOS 10.0, *) {
            estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        let viewWidth = collectionView?.bounds.width ?? 0
        let groups = Dictionary(grouping: attributes) { $0.frame.origin.y }

        for (_, group) in groups {
            let totalWidth = group.reduce(0) { $0 + $1.frame.width }
            let rowWidth = totalWidth + CGFloat(group.count - 1) * minimumInteritemSpacing
            let inset: CGFloat

            switch alignment {
            case .left: inset = sectionInset.left
            case .center: inset = (viewWidth - rowWidth) / 2
            case .right: inset = viewWidth - rowWidth - sectionInset.right
            }

            var x = inset

            for attributes in group {
                attributes.frame.origin.x = x
                x += attributes.frame.width + minimumInteritemSpacing
            }
        }

        return attributes
    }
}
