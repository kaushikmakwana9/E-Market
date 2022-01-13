//
//  ProductListVC.swift
//  E-Market
//
//  Created by Kaushik Makwana on 11/01/22.
//

import UIKit
import Cosmos

class ProductListVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var productListCV: UICollectionView!
    @IBOutlet var lblStoreName: UILabel!
    @IBOutlet var lblOpenTime: UILabel!
    @IBOutlet var lblCloseTime: UILabel!
    @IBOutlet var ratingView: CosmosView!
    @IBOutlet var containerView: UIView!
    
    var objStoreInfo = StoreInfoModelClass()
    var arrProductList = [ProductListModelClass]()
    var cart_counter = 0
    var arrProductCart = [ProductListModelClass]()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
        self.productListCV.register(ProductListCVC.self)
        self.productListCV.delegate = self
        self.productListCV.dataSource = self
        
        self.getStoreInfoApiCall()
    }

    func configureStoreinfoView(){
        self.lblStoreName.text = self.objStoreInfo.name
        self.lblOpenTime.text = self.objStoreInfo.openingTime
        self.lblCloseTime.text = self.objStoreInfo.closingTime
        self.ratingView.rating = self.objStoreInfo.rating
        self.containerView.isHidden = false
        self.productListCV.reloadData()
    }
    
    func addOrRemoveToCart(objProduct: ProductListModelClass, isAdd: Bool){
        if isAdd{
            if self.arrProductCart.count == 0 {
                self.arrProductCart.append(objProduct)
            } else {
                var flag = false
                var index = 0
                for obj in self.arrProductCart {
                    if obj.id == objProduct.id{
                        flag = true
                        break
                    }
                    index += 1
                }
                if flag{
                    self.arrProductCart[index] = objProduct
                } else {
                    self.arrProductCart.append(objProduct)
                }
            }
        } else {
            var index = 0
            for obj in self.arrProductCart {
                if obj.id == objProduct.id{
                    break
                }
                index += 1
            }
            if arrProductCart[index].cart_count == 0 {
                self.arrProductCart.remove(at: index)
            } else {
                self.arrProductCart[index] = objProduct
            }
        }
    }
    
    //MARK: - Button Actions
    
    @IBAction func orderSummaryBtnClicked(_ sender: UIButton) {
        if self.cart_counter <= 0 {
            self.showToast(message: "Add atleast one item to cart", font: UIFont.systemFont(ofSize: 17))
        } else {
            let orderSummaryVC = OrderSummaryVC.loadFromNib()
            orderSummaryVC.arrProductList = self.arrProductCart
            self.navigationController?.pushViewController(orderSummaryVC, animated: true)
        }
    }
    
    //MARK: - API Integrations
    
    func getStoreInfoApiCall() {
        
        Utility.showLoader(msg: "Please wait...")
        ApiManager.shared.getAPICall(url: getUrl(API_GET_STORE_INFO), headersRequired: false, params: [:]) { (response, isInternetAvailable) in
            Utility.hideLoader()
            if(isInternetAvailable) {
                switch response!.result{
                case .success(let JSON):
                    print("JSON : \(JSON)")
                    let responseDict = JSON as! NSDictionary
                    self.objStoreInfo = StoreInfoModelClass.parseStoreInfoData(dict: responseDict)
                    self.getProductListApiCall()
                case .failure(let error):
                    print("ERR : \(error.localizedDescription)")
                    self.showToast(message: "Something went wrong!", font: UIFont.systemFont(ofSize: 17))
                }
            }else{
                self.showToast(message: "Something went wrong!", font: UIFont.systemFont(ofSize: 17))
            }
        }
    }
    
    func getProductListApiCall() {
        
        Utility.showLoader(msg: "Please wait...")
        ApiManager.shared.getAPICall(url: getUrl(API_GET_LIST_OF_PRODUCT), headersRequired: false, params: [:]) { (response, isInternetAvailable) in
            Utility.hideLoader()
            if(isInternetAvailable) {
                switch response!.result{
                case .success(let JSON):
                    print("JSON : \(JSON)")
                    let responseArray = JSON as! NSArray
                    self.arrProductList = ProductListModelClass.parseStoreInfoArray(dataArray: responseArray)
                    self.configureStoreinfoView()
                case .failure(let error):
                    print("ERR : \(error.localizedDescription)")
                    self.showToast(message: "Something went wrong!", font: UIFont.systemFont(ofSize: 17))
                }
            }else{
                self.showToast(message: "Something went wrong!", font: UIFont.systemFont(ofSize: 17))
            }
        }
    }
}

// MARK: - Collection View Delegate and DataSource

extension ProductListVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrProductList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeue(ProductListCVC.self, forIndexPath: indexPath)
        cell.configureHomeProductCell(model: self.arrProductList[indexPath.item])
        cell.addProductAction = {
            self.cart_counter += 1
            self.arrProductList[indexPath.item].cart_count += 1
            self.addOrRemoveToCart(objProduct: self.arrProductList[indexPath.item], isAdd: true)
            self.productListCV.reloadItems(at: [indexPath])
        }
        cell.plusProductAction = {
            self.cart_counter += 1
            self.arrProductList[indexPath.item].cart_count += 1
            self.addOrRemoveToCart(objProduct: self.arrProductList[indexPath.item], isAdd: true)
            self.productListCV.reloadItems(at: [indexPath])
        }
        cell.minusProductAction = {
            self.cart_counter -= 1
            self.arrProductList[indexPath.item].cart_count -= 1
            self.addOrRemoveToCart(objProduct: self.arrProductList[indexPath.item], isAdd: false)
            self.productListCV.reloadItems(at: [indexPath])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = ((collectionView.frame.width - 10)  / 2)
        return CGSize(width: widthPerItem, height: 200)
    }
}
