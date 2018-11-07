//
//  BaseViewController.swift
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

@available(iOS 11.0, *)
open class BaseViewController: UIViewController {
    public struct NavTint {
        public enum Background {
            case color(UIColor?)
            case image(UIImage?, UIImage?)
        }

        public static let light = NavTint(background: .color(.white), foreground: .black, statusBar: .default)
        public static let dark = NavTint(background: .color(.black), foreground: .white, statusBar: .lightContent)

        public var background: Background
        public var foreground: UIColor?
        public var statusBar: UIStatusBarStyle

        public init(background: Background, foreground: UIColor?, statusBar: UIStatusBarStyle) {
            self.background = background
            self.foreground = foreground
            self.statusBar = statusBar
        }
    }

    public static var navBackImage: UIImage?
    public static var backImage: UIImage?
    public static var closeImage: UIImage?

    open var showsNavBar = false { didSet { updateShowsNavBar() } }
    open var showsCustomNavBar = false { didSet { updateShowsCustomNavBar() } }
    open var navBarAlpha: CGFloat = 1 { didSet { updateNavBarAlpha() } }

    open var showsNavBack = true { didSet { updateShowsNavBack() } }
    open var showsBack = false { didSet { updateShowsBack() } }

    open var showsNavClose = false { didSet { updateShowsNavClose() } }
    open var showsClose = false { didSet { updateShowsClose() } }

    open var navTint = NavTint.light { didSet { updateNavTint() } }
    open var canInteractivePop = true { didSet { updateInteractivePop() } }

    private let buttonSize: CGFloat = 44

    open private(set) var customNavBar: UINavigationBar?
    private var backButton: UIButton?
    private var closeButton: UIButton?

    open override var preferredStatusBarStyle: UIStatusBarStyle { return navTint.statusBar }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    open func commonInit() {}

    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let bar = navigationController?.navigationBar {
            bar.backIndicatorImage = BaseViewController.navBackImage
            bar.backIndicatorTransitionMaskImage = BaseViewController.navBackImage
        }

        updateShowsNavBar()
        updateNavTint()
        updateInteractivePop()
    }

    open func hide(animated: Bool = false) {
        if let nav = navigationController, nav.viewControllers.count > 1 {
            nav.popViewController(animated: animated)
        } else {
            dismiss(animated: animated)
        }
    }

    @objc private func buttonTapped(_ sender: Any) {
        hide(animated: true)
    }

    private func updateShowsNavBar() {
        navigationController?.isNavigationBarHidden = !showsNavBar
    }

    private func updateShowsCustomNavBar() {
        if showsCustomNavBar && customNavBar == nil {
            let bar = UINavigationBar()
            bar.translatesAutoresizingMaskIntoConstraints = false
            bar.delegate = self
            bar.backIndicatorImage = BaseViewController.navBackImage
            bar.backIndicatorTransitionMaskImage = BaseViewController.navBackImage
            bar.items = [navigationItem]
            view.addSubview(bar)

            bar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            bar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            bar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true

            customNavBar = bar
            updateNavBarAlpha()
            updateNavBarTint(bar)
        } else if !showsCustomNavBar && customNavBar != nil {
            customNavBar?.removeFromSuperview()
            customNavBar = nil
        }
    }

    private func updateNavBarAlpha() {
        customNavBar?.alpha = navBarAlpha
    }

    private func updateShowsNavBack() {
        navigationItem.hidesBackButton = !showsNavBack
    }

    private func updateShowsBack() {
        backButton = updateShowsButton(showsBack, button: backButton) {
            addButton(image: BaseViewController.backImage, leading: true)
        }
    }

    private func updateShowsNavClose() {
        let action = #selector(buttonTapped(_:))

        if showsNavClose {
            let item = UIBarButtonItem(
                image: BaseViewController.closeImage,
                style: .plain,
                target: self,
                action: action
            )
            updateItemTint(item)
            navigationItem.rightBarButtonItem = item
        } else if navigationItem.rightBarButtonItem?.action == action {
            navigationItem.rightBarButtonItem = nil
        }
    }

    private func updateShowsClose() {
        closeButton = updateShowsButton(showsClose, button: closeButton) {
            addButton(image: BaseViewController.closeImage, leading: false)
        }
    }

    private func updateNavTint() {
        updateNavBarTint(navigationController?.navigationBar)
        updateNavBarTint(customNavBar)
        updateItemTint(navigationItem.rightBarButtonItem)
        updateButtonTint(backButton)
        updateButtonTint(closeButton)
        setNeedsStatusBarAppearanceUpdate()
    }

    private func updateInteractivePop() {
        guard let nav = navigationController as? NavigationController else { return }
        nav.canInteractivePop = canInteractivePop
    }

    private func updateShowsButton(_ shows: Bool, button: UIButton?, add: () -> UIButton) -> UIButton? {
        var button = button

        if shows && button == nil {
            button = add()
            updateButtonTint(button)
        } else if !shows && button != nil {
            button?.removeFromSuperview()
            button = nil
        }

        view.layoutMargins.top = showsBack || showsClose ? buttonSize : 0
        return button
    }

    private func addButton(image: UIImage?, leading: Bool) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.image = image
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)

        if leading {
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        } else {
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        }

        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        return button
    }

    private func updateNavBarTint(_ bar: UINavigationBar?) {
        guard let bar = bar else { return }
        bar.tintColor = navTint.foreground
        bar.titleTextAttributes = navTint.foreground.map { [.foregroundColor: $0] }

        switch navTint.background {
        case let .color(color):
            if color != nil {
                bar.barTintColor = color
                bar.setBackgroundImage(nil, for: .default)
            } else {
                bar.setBackgroundImage(UIImage(), for: .default)
                bar.shadowImage = UIImage()
                bar.isTranslucent = true
            }
        case let .image(image, shadow):
            bar.setBackgroundImage(image, for: .default)
            bar.shadowImage = shadow
        }
    }

    private func updateItemTint(_ item: UIBarButtonItem?) {
        item?.tintColor = navTint.foreground
    }

    private func updateButtonTint(_ button: UIButton?) {
        button?.tintColor = navTint.foreground
    }
}

@available(iOS 11.0, *)
extension BaseViewController: UINavigationBarDelegate {
    open func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
