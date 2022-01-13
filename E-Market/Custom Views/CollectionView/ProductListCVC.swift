//
//  ProductListCVC.swift
//  E-Market
//
//  Created by Kaushik Makwana on 11/01/22.
//

import UIKit
import SDWebImage

class ProductListCVC: UICollectionViewCell {

    //MARK: - Outlets
    @IBOutlet var containerView: UIView!
    @IBOutlet var plusMinusView: UIView!
    @IBOutlet var addContainerView: UIView!
    @IBOutlet var imgProduct: UIImageView!
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var btnPlus: UIButton!
    @IBOutlet var btnMinus: UIButton!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var txtQuantity: UITextField!
    @IBOutlet var lblQuantity: UILabel!
    @IBOutlet var qtyContainerView: UIView!
    
    var addProductAction = {}
    var plusProductAction = {}
    var minusProductAction = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK:- Cell Configure Functions
    
    func configureHomeProductCell(model: ProductListModelClass){
        self.lblProductName.text = model.name

        self.imgProduct.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imgProduct.sd_setImage(with: URL(string: model.imageUrl), placeholderImage: UIImage(named: "ic_user"), options: .continueInBackground, context: nil)
        self.lblPrice.text = "$ \(model.price.clean)"
        self.txtQuantity.text = "\(model.cart_count)"

        if model.cart_count > 0 {
            self.addContainerView.isHidden = true
            self.plusMinusView.isHidden = false
        } else {
            self.addContainerView.isHidden = false
            self.btnAdd.isHidden = false
            self.plusMinusView.isHidden = true
        }
    }
    
    func configureOrderSummaryCell(model: ProductListModelClass){
        self.lblProductName.text = model.name
        
        self.imgProduct.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imgProduct.sd_setImage(with: URL(string: model.imageUrl), placeholderImage: UIImage(named: "ic_user"), options: .continueInBackground, context: nil)
        self.lblPrice.text = "$ \(model.price.clean)"
        self.lblQuantity.text = "Qty: \(model.cart_count)"
        
        self.addContainerView.isHidden = true
        self.plusMinusView.isHidden = true
        self.qtyContainerView.isHidden = false
    }
    
    //MARK:- Button Actions
    
    @IBAction func addProductBtnClicked(_ sender: UIButton) {
        addProductAction()
    }
    
    @IBAction func plsuProductBtnClicked(_ sender: UIButton) {
        plusProductAction()
    }
    
    @IBAction func minusProductBtnClicked(_ sender: UIButton) {
        minusProductAction()
    }
}
