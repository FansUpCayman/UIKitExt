//
//  UITableView.swift
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

extension UITableView: RegisterDequeueable {
    public func register<Cell: UIView>(_ type: Cell.Type) {
        register(type, forCellReuseIdentifier: String(describing: type))
    }

    public func registerHeader<Header: UIView>(_ type: Header.Type) {
        register(type, forHeaderFooterViewReuseIdentifier: String(describing: type))
    }

    public func registerFooter<Footer: UIView>(_ type: Footer.Type) {
        registerHeader(type)
    }

    public func dequeue<Cell: UIView>(_ type: Cell.Type, for indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as! Cell
    }

    public func dequeueHeader<Header: UIView>(_ type: Header.Type, for indexPath: IndexPath) -> Header {
        return dequeueReusableHeaderFooterView(withIdentifier: String(describing: type)) as! Header
    }

    public func dequeueFooter<Footer: UIView>(_ type: Footer.Type, for indexPath: IndexPath) -> Footer {
        return dequeueHeader(type, for: indexPath)
    }
}
