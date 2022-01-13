//
//  ApiUrls.swift
//  E-Market
//
//  Created by Kaushik Makwana on 11/01/22.
//

import Foundation

func getUrl(_ endPoint:String) -> String {
    return BASE_URL + endPoint
}

var BASE_URL                            =   "https://c8d92d0a-6233-4ef7-a229-5a91deb91ea1.mock.pstmn.io/"

var API_GET_STORE_INFO                  =   "storeInfo"

var API_GET_LIST_OF_PRODUCT             =   "products"

var API_POST_MAKE_AN_ORDER              =   "order"
