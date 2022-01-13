//
//  ApiManager.swift
//  E-Market
//
//  Created by Kaushik Makwana on 11/01/22.
//

import UIKit
import Alamofire

let ServiceManager = ApiManager.shared

class ApiManager: NSObject {
    
    static let shared = ApiManager()
    
    //MARK:- =================== COMMON ===================
    
    private func callGET_POSTApi(reqMethod: HTTPMethod, url : String, headersRequired : Bool, params : [String : Any]?, completionHandler : @escaping (AFDataResponse<Any>?,Bool) -> Void){
                
        let headers: HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded", "Accept": "application/json"]
        
        let parameter = params
        
        print("\n\nURL : \(url) \nPARAM : \(getStringFromDictionary(dict: parameter!)) \nHEADERS : \(headers)")
        
        AF.request(url, method: reqMethod, parameters: parameter, encoding: URLEncoding.default, headers: headers)
            .responseJSON { (response) in
            
            switch response.result{
            case .success( _):
                completionHandler(response,true)
            case .failure( _):
                completionHandler(response,true)
            }
        }
    }
    
    private func call_POST_Body_Api(reqMethod: HTTPMethod, url : String, headersRequired : Bool, jsonData : String?, completionHandler : @escaping (AFDataResponse<Any>?,Bool) -> Void){
                
        let headers: HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded", "Accept": "application/json"]
                
        print("\n\nURL : \(url) \nPARAM : \(jsonData!) \nHEADERS : \(headers)")
        
        let url = URL(string: url)!
        let jsonData = jsonData?.data(using: .utf8, allowLossyConversion: false)!

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        AF.request(request)
            .responseJSON { (response) in
            
            switch response.result{
            case .success( _):
                completionHandler(response,true)
            case .failure( _):
                completionHandler(response,true)
            }
        }
    }
    
    //MARK:- ******** COMMON MULTIPART METHOD *********
    
    private func callUPLOADApiWithNetCheck(url : String, image:UIImage?, headersRequired : Bool, params : [String : Any]?, completionHandler : @escaping (AFDataResponse<Any>?,Bool) -> Void){
        
        let headers:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded", "Accept": "application/json"]
        
        print("\n\n\n\n\nURL : \(url) \nPARAM : \(getStringFromDictionary(dict: params!)) \nHEADERS : \(headers)")
        
        AF.upload(multipartFormData:{ multipartFormData in
            
            if let params = params {
                for eachKey in params.keys {
                    if let value = params[eachKey] as? String {
                        multipartFormData.append(value.data(using: .utf8)!, withName: eachKey)
                    }
                }
            }
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyyMMddHHmmsss"
            let imgName = dateFormatterGet.string(from: Date())
            
            if let image = image {
                if let imageData = image.jpegData(compressionQuality: 0.5)  {
                    multipartFormData.append(imageData, withName: "file", fileName: "\(imgName)_eparish.jpg", mimeType: "image/jpeg")//profile_picture
                }
            }
        },
                  to:url, usingThreshold:UInt64.init(),
                  method:.post,
                  headers:headers).responseJSON { (response) in
            
            switch response.result{
            case .success( _):
                completionHandler(response,true)
            case .failure( _):
                completionHandler(nil,true)
            }
        }
        /*encodingCompletion: { encodingResult in
         
         switch encodingResult {
         case .success(let upload, _, _):
         upload
         .responseJSON { response in
         completionHandler(response,true)
         }
         case .failure(let encodingError):
         print("ERR: UPLOAD: \(encodingError.localizedDescription)")
         completionHandler(nil,true)
         }
         }*/
        //        )
    }
    
    
    func getAPICall(url : String, headersRequired : Bool, params : [String : Any]?, completionHandler : @escaping (AFDataResponse<Any>?,Bool) -> Void){
        if Utility.isInternetAvailable(){
        self.callGET_POSTApi(reqMethod: .get, url: url, headersRequired: headersRequired, params: params, completionHandler: completionHandler)
        }else{
            DispatchQueue.main.async {
                completionHandler(nil,false)
            }
        }
    }
    
    func postAPICall(url : String, headersRequired : Bool, params : [String : Any]?, completionHandler : @escaping (AFDataResponse<Any>?,Bool) -> Void){
        if Utility.isInternetAvailable(){
            self.callGET_POSTApi(reqMethod: .post, url: url, headersRequired: headersRequired, params: params, completionHandler: completionHandler)
        }else{
            DispatchQueue.main.async {
                completionHandler(nil,false)
            }
        }
    }
    
    func postBodyAPICall(url : String, headersRequired : Bool, json : String?, completionHandler : @escaping (AFDataResponse<Any>?,Bool) -> Void){
        if Utility.isInternetAvailable(){
            self.call_POST_Body_Api(reqMethod: .post, url: url, headersRequired: headersRequired, jsonData: json, completionHandler: completionHandler)
        }else{
            DispatchQueue.main.async {
                completionHandler(nil,false)
            }
        }
    }
    
    func putAPICall(url : String, headersRequired : Bool, params : [String : Any]?, completionHandler : @escaping (AFDataResponse<Any>?,Bool) -> Void){
        if Utility.isInternetAvailable(){
            self.callGET_POSTApi(reqMethod: .put, url: url, headersRequired: headersRequired, params: params, completionHandler: completionHandler)
        }else{
            DispatchQueue.main.async {
                completionHandler(nil,false)
            }
        }
    }
    
    func deleteAPICall(url : String, headersRequired : Bool, params : [String : Any]?, completionHandler : @escaping (AFDataResponse<Any>?,Bool) -> Void){
        if Utility.isInternetAvailable(){
            self.callGET_POSTApi(reqMethod: .delete, url: url, headersRequired: headersRequired, params: params, completionHandler: completionHandler)
        }else{
            DispatchQueue.main.async {
                completionHandler(nil,false)
            }
        }
    }
    
    func uploadAPICall(url : String, uploadImage: UIImage, headersRequired : Bool, params : [String : Any]?, completionHandler : @escaping (AFDataResponse<Any>?,Bool) -> Void){
        if Utility.isInternetAvailable(){
            self.callUPLOADApiWithNetCheck(url: url, image: uploadImage, headersRequired: headersRequired, params: params, completionHandler : completionHandler)
        }else{
            DispatchQueue.main.async {
                completionHandler(nil,false)
            }
        }
    }
}
