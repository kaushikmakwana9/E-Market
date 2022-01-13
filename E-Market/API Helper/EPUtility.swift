//
//  Utility.swift
//  E-Market
//
//  Created by Kaushik Makwana on 11/01/22.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class Utility {
    
    class func showLoader(msg:String = ""){
        if (NVActivityIndicatorPresenter.sharedInstance.isAnimating == false) {
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData.init(size: CGSize(width: 70, height: 70), message: msg,  type: NVActivityIndicatorType.ballPulse))
        }
    }
    
    class func hideLoader(){
        if (NVActivityIndicatorPresenter.sharedInstance.isAnimating == true) {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
    }
    
    class func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    class func encodeUrl(url:String) ->String{
        return url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    class func changeDateFormat(date:String)->String{
        let inputFormatter = DateFormatter();
        inputFormatter.dateFormat = "yyyy-mm-dd";
        let showDate = inputFormatter.date(from: date);
        inputFormatter.dateFormat = "dd-mm-yy";
        let resultString = inputFormatter.string(from: showDate!);
        return resultString;
    }

    
    class func removeFromUserDefault(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getCurrentMonth()->Int{
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        return month;
    }
    
    class func getCurrentTime() ->String{
        let date = NSDate()
        // *** create calendar object ***
        var calendar = NSCalendar.current
        
        // *** Get components using current Local & Timezone ***
        print(calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date as Date))
        
        // *** define calendar components to use as well Timezone to UTC ***
        let unitFlags = Set<Calendar.Component>([.hour, .year, .minute])
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        // *** Get All components from date ***
        let components = calendar.dateComponents(unitFlags, from: date as Date)
        print("All Components : \(components)")
        
        // *** Get Individual components from date ***
        let hour = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        let seconds = calendar.component(.second, from: date as Date)
        let finalString = String(hour) + ":" + String(minutes) + ":" + String(seconds)
        let strTime = Utility.formattedDateFromString(dateString: finalString, existFormat: "HH:mm:ss", withFormat: "H:mm a")!
        print("current time\(hour):\(minutes):\(seconds)")
        return strTime
    }
    
    class func isInternetAvailable() -> Bool{
        let reachable = Reachability();
        Utility.updateOnlineStatus();
        return reachable?.isReachable==true ? true :false
    }
    
    class func updateOnlineStatus(){
        let reachable = Reachability();
        if(reachable?.isReachable != true){
        }
    }
    
    class func isWifiAvaliable()-> Bool{
        let reachable = Reachability()
        return (reachable?.isReachableViaWiFi)!;
    }
    
    class func showAlert(title:String, message:String,controller:UIViewController){
        controller.view.endEditing(true)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
        controller.present(alert, animated: true, completion: nil)
    }
    
    class func showAlertWithTwoButton(title:String, message:String,controller:UIViewController, buttonOneTitle: String, buttonTwoTitle: String, completionBlock: @escaping (_ buttonIndex: Int)-> Void){
        controller.view.endEditing(true)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonOneTitle, style: .default, handler: { action in
            completionBlock(0)
        }))
        alert.addAction(UIAlertAction(title: buttonTwoTitle, style: .destructive, handler: { action in
            completionBlock(1)
        }))
        controller.present(alert, animated: true, completion: nil)
    }
    
    class func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
    
    class func writeUserDefaultString(key:String,value:String){
        UserDefaults.standard.set(value, forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    class func readUserDefaultString(key:String) -> String{
        if (UserDefaults.standard.string(forKey: key)==nil) {
            return ""
        }else{
            return UserDefaults.standard.string(forKey: key)!
        }
    }
    
    class func writeUserDefaultAny(key:String,value:Any){
        UserDefaults.standard.set(value, forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    class func readUserdefaultAny(key:String) -> Any?{
        return UserDefaults.standard.value(forKey:key)
    }
    
    class func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    class func getScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    class func getScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.white
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func arrayToJSONStinrg(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    class func estimatedHeightOfLabel(text: String,width:CGFloat,font:UIFont) -> CGFloat {
        let size = CGSize(width: width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: font]
        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height
        return rectangleHeight
    }

    class func estimatedWidthOfLabel(text: String,height:CGFloat,font:UIFont) -> CGFloat {
        let constraintRect = CGSize(width: 1000, height: height)
        let boundingBox = String(text).boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.width
    }
    
    class func setPlaceholderColor(textField: UITextField, placeholderText: String, color:String) {
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: Utility.hexStringToUIColor(hex: color).withAlphaComponent(1.0)])
    }
    
    class func setPlaceholderColorWithAlpha(textField: UITextField, placeholderText: String, color:String,alpha:CGFloat) {
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: Utility.hexStringToUIColor(hex: color).withAlphaComponent(alpha)])
    }
    
    class func decorateLabel(label:UILabel,borderColor:String,borderWidth:CGFloat,cornerRadius:CGFloat){
        label.layer.cornerRadius = cornerRadius
        label.layer.borderColor = Utility.hexStringToUIColor(hex: borderColor).cgColor
        label.layer.borderWidth = borderWidth
    }

    class func createRedBorder(view:UIView){
        view.layer.cornerRadius = 0
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.borderWidth = 1
    }

    class func removeBorder(view:UIView){
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.borderWidth = 0
    }
    
    class func addBorder(view: UIView, color: UIColor){
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = 1
    }
    
    class func setTintColor(view: UIView, color: UIColor) {
        view.tintColor = color
    }
    
    class func decorateView(view:UIView,borderColor:String,borderWidth:CGFloat,cornerRadius:CGFloat){
        view.layer.cornerRadius = cornerRadius
        view.layer.borderColor = Utility.hexStringToUIColor(hex: borderColor).cgColor
        view.layer.borderWidth = borderWidth
    }
    
    class func clearColor(view: UIView) {
        view.layer.backgroundColor = UIColor.clear.cgColor
        view.layer.borderColor = UIColor.black.cgColor
    }
    
    class func addBackGroundColor(view: UIView) {
        view.layer.backgroundColor = UIColor.black.cgColor
        view.layer.borderColor = UIColor.clear.cgColor
    }

    class func addBackGroundClearColor(view: UIView) {
        view.layer.backgroundColor = UIColor.clear.cgColor
        view.layer.borderColor = UIColor.clear.cgColor
    }
        
    class func decorateButton(button:UIButton,borderColor:String,borderWidth:CGFloat,cornerRadius:CGFloat){
        button.layer.cornerRadius = cornerRadius
        button.layer.borderColor = Utility.hexStringToUIColor(hex: borderColor).cgColor
        button.layer.borderWidth = borderWidth
    }
    
    class func addShadowToButtonWithCornerRedious(button:UIButton, cornerRadius:CGFloat) {
        button.layer.masksToBounds = false
        button.layer.shadowOpacity = 3.0
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 2.0
        button.layer.cornerRadius = cornerRadius / 2
        button.layer.shadowColor = UIColor.black.cgColor
    }
    
    class func formattedDateFromString(dateString: String,existFormat:String, withFormat format: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = existFormat
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            return outputFormatter.string(from: date)
        }
        return nil
    }
    
    class func UTCToLocal(date:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let localDate = dateFormatter.date(from: date)
        return localDate!
    }
    
    class func stringFromDate(_ date: Date, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    class func dateFromString(_ str: String, format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: str)!
    }
    
    class func stringFromString(_ str: String, format: String = "yyyy-MM-dd HH:mm:ss", requiredformat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let dt = formatter.date(from: str)!
        formatter.dateFormat = requiredformat
        return formatter.string(from: dt)
    }
    
    class func convertTimeToGMT(_ str: String, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dt = self.dateFromString(str)!
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier:"GMT")
        return formatter.string(from: dt)
    }
    
    class func convertTimeToLocal(_ str: String, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier:"GMT")
        let dt_gmt = formatter.date(from: str)!
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        return formatter.string(from: dt_gmt)
    }
    
    class func convertDateForMessage(str: String) -> String {
        let date = self.dateFromString(str)!
        return self.stringFromDate(date, format: "MMM dd, HH:mm")
    }
    
    class func isoStringFromDate(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: date)
    }
    
    class func isoDateFromString(_ str: String) -> Date {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: str)!
    }
    
    class func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    class func getPrifixZeroFrom(data: Int) -> String {
        
        return data < 10 ? "0\(data)" : "\(data)"
    }
    
    class func checkNetworkSpeed(completionHandler : @escaping (CGFloat) -> Void) {
        
        let url = URL(string: "https://www.google.com/")
        let request = URLRequest(url: url!)
        
        let session = URLSession.shared
        
        let startTime = Date()
        
        let task =  session.dataTask(with: request) { (data, resp, error) in
            
            guard error == nil && data != nil else{
                
                print("connection error or data is nill")
                
                return completionHandler(0)
            }
            
            guard resp != nil else{
                
                print("respons is nill")
                return completionHandler(0)
            }
            
            let length  = CGFloat( (resp?.expectedContentLength)!) / 1000000.0
            
            print(length)
            
            let elapsed = CGFloat( Date().timeIntervalSince(startTime))
            
            print("elapsed: \(elapsed)")
            
            print("Speed: \(length/elapsed) Mb/sec")
            return completionHandler(length/elapsed)
        }
        task.resume()
    }
    
    class func deg2rad(deg:Double) -> Double {
        return deg * .pi / 180
    }
    
    class func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / .pi
    }
    
}

//MARK:- STRING FROM DICT
func getStringFromDictionary(dict:Any) -> String{
    var strJson = ""
    do {
        let data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        strJson = String(data: data, encoding: String.Encoding.utf8)!
    } catch let error as NSError {
        print("json error: \(error.localizedDescription)")
    }
    
    return strJson
}
