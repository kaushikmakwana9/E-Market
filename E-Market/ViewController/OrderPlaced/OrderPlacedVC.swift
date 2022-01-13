//
//  OrderPlacedVC.swift
//  E-Market
//
//  Created by Kaushik Makwana on 12/01/22.
//

import UIKit

class OrderPlacedVC: UIViewController {

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - Button Actions
    
    @IBAction func goToHomeBtnClicked(_ sender: UIButton) {
        let vc = ProductListVC.loadFromNib()
        AppDelegate.shared.window?.rootViewController = UINavigationController(rootViewController: vc)
        AppDelegate.shared.window?.makeKeyAndVisible()
    }

}
