//
//  NibLoadable.swift
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

public protocol NibLoadable {}

@available(iOS 9.0, *)
extension NibLoadable where Self: UIView {
    func loadView() -> UIView? {
        let t = type(of: self)
        let bundle = Bundle(for: t)
        let objects = bundle.loadNibNamed(String(describing: t), owner: self)
        return objects?.first as? UIView
    }

    func loadView(to destView: UIView) {
        guard let view = loadView() else { return }
        view.translatesAutoresizingMaskIntoConstraints = false
        destView.addSubview(view)

        view.leadingAnchor.constraint(equalTo: destView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: destView.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: destView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: destView.bottomAnchor).isActive = true
    }
}

@available(iOS 9.0, *)
open class NibView: UIView, NibLoadable {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    open func commonInit() {
        loadView(to: self)
    }
}

@available(iOS 9.0, *)
open class NibCollectionViewCell: UICollectionViewCell, NibLoadable {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    open func commonInit() {
        loadView(to: contentView)
    }
}

@available(iOS 9.0, *)
open class NibCollectionReusableView: UICollectionReusableView, NibLoadable {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    open func commonInit() {
        loadView(to: self)
    }
}

@available(iOS 9.0, *)
open class NibTableViewCell: UITableViewCell, NibLoadable {
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    open func commonInit() {
        backgroundColor = nil
        selectionStyle = .none
        loadView(to: contentView)
    }
}

@available(iOS 9.0, *)
open class NibTableViewHeaderFooterView: UITableViewHeaderFooterView, NibLoadable {
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    open func commonInit() {
        backgroundView = UIView()
        loadView(to: contentView)
    }
}

@available(iOS 9.0, *)
open class NibStackView: UIStackView, NibLoadable {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        guard let view = loadView() else { return }
        addArrangedSubview(view)
    }
}
