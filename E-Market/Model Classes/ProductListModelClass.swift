//
//  ProductListModelClass.swift
//  E-Market
//
//  Created by Kaushik Makwana on 11/01/22.
//

import Foundation

class ProductListModelClass {
    var id          : Int = 0
    var name        : String = ""
    var price       : Double = 0.0
    var imageUrl    : String = ""
    var cart_count  : Int = 0
    
    public class func parseStoreInfoData(dict: NSDictionary) -> ProductListModelClass {
        let obj         = ProductListModelClass()
        obj.name        = dict.value(forKey: "name") as? String ?? ""
        obj.price       = dict.value(forKey: "price") as? Double ?? 0.0
        obj.imageUrl    = dict.value(forKey: "imageUrl") as? String ?? ""
        return obj
    }
    
    public class func parseStoreInfoArray(dataArray: NSArray) -> [ProductListModelClass] {
        var objArray  = [ProductListModelClass]()
        var index = 0
        for i in dataArray {
            let dict = i as! NSDictionary
            let obj  = parseStoreInfoData(dict: dict)
            obj.id = index
            objArray.append(obj)
            index += 1
        }
        return objArray
    }
}

class PostProductModelClass {
    var name        : String = ""
    var price       : Double = 0.0
    var imageUrl    : String = ""
}

class PostProductListModelClass {
    var delivery_address : String = ""
    var products = [PostProductModelClass]()
}
