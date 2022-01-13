//
//  StoreInfoModelClass.swift
//  E-Market
//
//  Created by Kaushik Makwana on 11/01/22.
//

import Foundation
class StoreInfoModelClass {
    var name        : String = ""
    var rating      : Double = 0.0
    var openingTime : String = ""
    var closingTime : String = ""
    
    public class func parseStoreInfoData(dict: NSDictionary) -> StoreInfoModelClass {
        let obj             = StoreInfoModelClass()
        obj.name            = dict.value(forKey: "name") as? String ?? ""
        obj.rating          = dict.value(forKey: "rating") as? Double ?? 0.0
        obj.openingTime     = dict.value(forKey: "openingTime") as? String ?? ""
        obj.closingTime     = dict.value(forKey: "closingTime") as? String ?? ""
        return obj
    }
}
