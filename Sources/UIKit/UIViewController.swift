//
//  UIViewController.swift
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

extension UIViewController {
    public var topMostViewController: UIViewController {
        if let tab = self as? UITabBarController, let selected = tab.selectedViewController {
            return selected.topMostViewController
        } else if let nav = self as? UINavigationController, let visible = nav.visibleViewController {
            return visible.topMostViewController
        } else if let presented = presentedViewController {
            return presented.topMostViewController
        } else {
            return self
        }
    }

    public func hide(animated: Bool = false) {
        if let nav = navigationController, nav.viewControllers.count > 1 {
            nav.popViewController(animated: animated)
        } else {
            dismiss(animated: animated)
        }
    }

    public func addChildAndSubview(_ childController: UIViewController) {
        addChild(childController) { view.addSubview($0) }
    }

    public func addChild(_ childController: UIViewController, add: (UIView) -> ()) {
        addChild(childController)
        add(childController.view)
        childController.didMove(toParent: self)
    }

    public func removeFromParentAndSuperview() {
        removeFromParent { $0.removeFromSuperview() }
    }

    public func removeFromParent(remove: (UIView) -> ()) {
        willMove(toParent: nil)
        remove(view)
        removeFromParent()
    }
}
