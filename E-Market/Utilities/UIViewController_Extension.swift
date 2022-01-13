//
//  UIViewController_Extension.swift
//  E-Market
//
//  Created by Kaushik Makwana on 11/01/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showToast(message: String, font: UIFont, isCenter: Bool = false) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = .white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        
        let maxWidthPercentage: CGFloat = 0.8
        let maxTitleSize = CGSize(width: Utility.getScreenWidth() * maxWidthPercentage, height: Utility.getScreenHeight() * maxWidthPercentage)
        var titleSize = toastLabel.sizeThatFits(maxTitleSize)
        titleSize.width += 20
        titleSize.height += 10
        if isCenter {
            toastLabel.frame = CGRect(x: Utility.getScreenWidth() / 2 - titleSize.width / 2, y: Utility.getScreenHeight() / 2, width: titleSize.width, height: titleSize.height)
        } else {
            toastLabel.frame = CGRect(x: Utility.getScreenWidth() / 2 - titleSize.width / 2, y: Utility.getScreenHeight() - 100, width: titleSize.width, height: titleSize.height)
        }
        
        Utility.topMostController().view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 3, delay: 2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
    
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        return instantiateFromNib()
    }
    
    func embed(_ viewController:UIViewController, inView view:UIView){
            viewController.willMove(toParent: self)
            viewController.view.frame = view.bounds
            view.addSubview(viewController.view)
            self.addChild(viewController)
            viewController.didMove(toParent: self)
        }
}

extension UINavigationController: UIGestureRecognizerDelegate {

    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
