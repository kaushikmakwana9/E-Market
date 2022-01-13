//
//  OrderSummaryVC.swift
//  E-Market
//
//  Created by Kaushik Makwana on 11/01/22.
//

import UIKit

class OrderSummaryVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var productListCV: UICollectionView!
    @IBOutlet var txtAddress: UITextField!
    @IBOutlet var lblTotal: UILabel!
    
    var arrProductList = [ProductListModelClass]()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.productListCV.register(ProductListCVC.self)
        self.productListCV.delegate = self
        self.productListCV.dataSource = self
        self.productListCV.reloadData()
        self.calculatedTotalPrice()
    }

    func calculatedTotalPrice(){
        var price = 0.0
        for obj in self.arrProductList{
            price += (Double(obj.cart_count) * obj.price)
        }
        self.lblTotal.text = "$ \(price.clean)"
    }
    
    //MARK: - Button Actions
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
        
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        if ((txtAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)) == ""){
            self.showToast(message: "Please add address", font: UIFont.systemFont(ofSize: 17))
        } else {
            self.postMakeAnOrderApiCall()
        }
    }
    
    //MARK: - API Integrations
    
    func postMakeAnOrderApiCall() {
        
        let objProductData = PostProductListModelClass()
        objProductData.delivery_address = self.txtAddress.text!
        for obj in self.arrProductList{
            let objProduct = PostProductModelClass()
            objProduct.name = obj.name
            objProduct.price = obj.price
            objProduct.imageUrl = obj.imageUrl
            objProductData.products.append(objProduct)
        }
        let jsonData = JSONSerializer.toJson(objProductData)
        Utility.showLoader(msg: "Please wait...")
        ApiManager.shared.postBodyAPICall(url: getUrl(API_POST_MAKE_AN_ORDER), headersRequired: false, json: jsonData) { (response, isInternetAvailable) in
            Utility.hideLoader()
            if(isInternetAvailable) {
                switch response!.result{
                case .success(let JSON):
                    print("JSON : \(JSON)")
                    let responseDict = JSON as! NSDictionary
                    let orderPlacedVC = OrderPlacedVC.loadFromNib()
                    self.navigationController?.pushViewController(orderPlacedVC, animated: true)

                case .failure(let error):
                    print("ERR : \(error.localizedDescription)")
                    if response?.response?.statusCode == 400{
                        let orderPlacedVC = OrderPlacedVC.loadFromNib()
                        self.navigationController?.pushViewController(orderPlacedVC, animated: true)
                    } else {
                        self.showToast(message: "Something went wrong!", font: UIFont.systemFont(ofSize: 17))
                    }
                }
            }else{
                self.showToast(message: "Something went wrong!", font: UIFont.systemFont(ofSize: 17))
            }
        }
    }
}

// MARK: - Collection View Delegate and DataSource

extension OrderSummaryVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrProductList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeue(ProductListCVC.self, forIndexPath: indexPath)
        cell.configureOrderSummaryCell(model: self.arrProductList[indexPath.item])
  
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = ((collectionView.frame.width - 10)  / 2)
        return CGSize(width: widthPerItem, height: 200)
    }
}
