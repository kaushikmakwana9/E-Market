//
//  AppDelegate.swift
//  E-Market
//
//  Created by Kaushik Makwana on 11/01/22.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        let vc = ProductListVC.loadFromNib()
        self.window?.rootViewController = UINavigationController(rootViewController: vc)
        self.window?.makeKeyAndVisible()
        return true
    }

}

