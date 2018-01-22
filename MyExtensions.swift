//
//  MyExtensions.swift
//  NeighboorhoodDriver
//
//  Created by Aqeel on 22/01/2018.
//  Copyright © 2018 Yamsol. All rights reserved.
//

import Foundation
import Braintree
import BraintreeDropIn


extension UIColor{
    
    func getThemeColor() -> UIColor{
        
        return UIColor(red: 0/255, green: 170/255, blue: 247/255, alpha: 1.0)
    }
    
    func getEarningSelectionColor() -> UIColor
    {
        return UIColor(red: 4/255, green: 43/255, blue: 62/255, alpha: 1.0)
    }
    
    func getNewColorForSelection() -> UIColor {
        return UIColor(red: 249/255, green: 177/255, blue: 30/255, alpha: 1.0)
    }
    
    func getNewBlackColor() -> UIColor {
        return UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1.0)
    }
    
    func pendingColor(isForDetail : Bool = false) -> UIColor
    {
        if (isForDetail)
        {
            return UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1.0)
        }
        
        return UIColor(red: 159/255, green: 159/255, blue: 159/255, alpha: 1.0)
    }
    
    func acceptedColor(isForDetail : Bool = false) -> UIColor
    {
        if (isForDetail)
        {
            return UIColor(red: 255/255, green: 233/255, blue: 213/255, alpha: 1.0)
        }
        
        return UIColor(red: 251/255, green: 123/255, blue: 8/255, alpha: 1.0)
    }
    
    func collectedColor(isForDetail : Bool = false) -> UIColor
    {
        if (isForDetail)
        {
            return UIColor(red: 212/255, green: 241/255, blue: 254/255, alpha: 1.0)
        }
        
        return UIColor(red: 37/255, green: 170/255, blue: 247/255, alpha: 1.0)
    }
    
    func deliveredColor(isForDetail : Bool = false) -> UIColor
    {
        if (isForDetail)
        {
            return UIColor(red: 212/255, green: 246/255, blue: 217/255, alpha: 1.0)
        }
        
        return UIColor(red: 48/255, green: 204/255, blue: 27/255, alpha: 1.0)
    }
    
    func cancelledColor(isForDetail : Bool = false) -> UIColor
    {
        if (isForDetail)
        {
            return UIColor(red: 159/255, green: 179/255, blue: 196/255, alpha: 1.0)
        }
        
        return UIColor(red: 52/255, green: 86/255, blue: 120/255, alpha: 1.0)
    }
    
    
    
    func deliveryDefaultColor() -> UIColor
    {
        //        return UIColor(red: 148/255, green: 24/255, blue: 227/255, alpha: 1.0)
        return UIColor.black
    }
    
    func getOrangeThemeColor() -> UIColor
    {
        return UIColor(red: 253/255, green: 123/255, blue: 5/255, alpha: 1.0)
        
    }
}

extension UIViewController
{
    func showInfoAlertWith(title : String, message : String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showInfoAlert(title titleIn:String?, message messageIn:String?, handler: (() -> Void)?){
        
        let alert=UIAlertController(title:titleIn, message:messageIn, preferredStyle: .alert);
        let alertActionOk = UIAlertAction(title:"Ok", style: .default, handler: { (UIAlertAction) in
            
            if handler != nil
            {
                handler!()
            }
        })
        alert.addAction(alertActionOk)
        present(alert, animated: true, completion: nil)
    }
    
    
    func showProgressLoader(withMessage message : String?)
    {
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        if let msg = message
        {
            //   progressHUD?.labelText = msg
        }
    }
    
    func hideProgressLoader()
    {
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }
    
    func delay(_ delay:Double, closure:@escaping ()->())
    {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func resize(image: UIImage, toSize size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height)))
        let destImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return destImage!
    }
    
    func showNavigationOptions(from source : CLLocationCoordinate2D, to destination : CLLocationCoordinate2D)
    {
        let sourceLatitude = source.latitude
        let sourceLongitude = source.longitude
        
        let destinationLatitude = destination.latitude
        let destinationLongitude = destination.longitude
        
        
        var isOtherSchemePresent = false
        
        let alertController = UIAlertController(title: "Selection Required", message: "Which application would you like to see directions in?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        //        "http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f"
        if(schemeAvailable(scheme: "comgooglemaps://"))
        {
            isOtherSchemePresent = true
            print("google maps installed")
            //            UIApplication.shared.openURL(URL(string:"https://www.google.com/maps/@42.585444,13.007813,6z")!)
            
            let googleMapsAction = UIAlertAction(title: "Google Maps", style: .default, handler: { (alertAction) in
                
                let googleMapUrl = "comgooglemaps://?saddr=\(sourceLatitude),\(sourceLongitude)&daddr=\(destinationLatitude),\(destinationLongitude)&directionsmode=driving"
                UIApplication.shared.openURL(URL(string: googleMapUrl)!)
            })
            
            alertController.addAction(googleMapsAction)
            
        }
        
        if(schemeAvailable(scheme: "waze://"))
        {
            isOtherSchemePresent = true
            print("waze maps installed")
            
            let wazeAction = UIAlertAction(title: "Waze", style: .default, handler: { (alertAction) in
                
                let wazeUrl = "waze://?ll=\(destinationLatitude),\(destinationLongitude)&navigate=yes"
                UIApplication.shared.openURL(URL(string: wazeUrl)!)
                
            })
            
            alertController.addAction(wazeAction)
            
        }
        
        // Apple Maps would be present always.
        let appleMapsUrl = "http://maps.apple.com/?saddr=\(sourceLatitude),\(sourceLongitude)&daddr=\(destinationLatitude),\(destinationLongitude)"
        
        // If other options available, show apple maps as an option too
        if (isOtherSchemePresent)
        {
            
            let appleMapsAction = UIAlertAction(title: "Apple Maps", style: .default, handler: { (alertAction) in
                
                UIApplication.shared.openURL(URL(string: appleMapsUrl)!)
            })
            alertController.addAction(appleMapsAction)
            
            present(alertController, animated: true, completion: nil)
        }
            // Otherwise, simply open the apple maps
        else
        {
            UIApplication.shared.openURL(URL(string: appleMapsUrl)!)
        }
        
        /*
         if(schemeAvailable(scheme: "com.sygic.aura://"))
         {
         print("Sygic maps installed")
         }
         */
        
    }
    
    // Helper Methods
    func schemeAvailable(scheme: String) -> Bool {
        if let url = URL(string: scheme) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    func imageFor(carType : String) -> String
    {
        var result = "standardCabIcon"
        if carType == "Standard"
        {
            result = "standardCabIcon"
        }
        else if carType == "Premium"
        {
            result = "blackCabIcon"
        }
            // For Both SUV & Cab+
        else
        {
            result = "suvCarIcon"
        }
        return result
    }
    
    func showDropIn(clientTokenOrTokenizationKey: String , completion: @escaping ((_ paymentNonce: String?) -> Void))
    {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
                completion(nil)
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
                completion(nil)
            } else if let result = result {
                // Use the BTDropInResult properties to update your UI
                // result.paymentOptionType
                // result.paymentMethod
                // result.paymentIcon
                // result.paymentDescription
                
                completion(result.paymentMethod?.nonce)
                
                print("response received from Drop in UI")
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    func bgImageFor(jobType : String ,size : ButtonSize) -> UIImage
    {
        var result = "btnYellowBg"
        if let type = JobType(rawValue: jobType)
        {
            if (type == .normal || type == .takeMeHome)
            {
                switch size {
                case .large:
                    result = "btnYellowBg"
                    break
                case .small:
                    result = "btnYellowBgSmall"
                    break
                }
            }
            else if (type == .priority)
            {
                result = "btnOrangeBg"
                
                switch size {
                case .large:
                    result = "btnOrangeBg"
                    break
                case .small:
                    result = "btnOrangeBgSmall"
                    break
                }
                
            }
            else if (type == .cooperate)
            {
                result = "btnGreenBg"
                
                switch size {
                case .large:
                    result = "btnGreenBg"
                    break
                case .small:
                    result = "btnGreenBgSmall"
                    break
                }
                
            }
            else
            {
                switch size {
                case .large:
                    result = "btnYellowBg"
                    break
                case .small:
                    result = "btnYellowBgSmall"
                    break
                }
            }
            
        }
        
        
        return UIImage(named: result)!
    }
    
    func bgColorFor( type : JobType) -> UIColor
    {
        var result = UIColor(red: 245/255, green: 162/255, blue: 25/255, alpha: 1)
        
        switch type {
            
            // Only differentitating priority call and corporate call.
            // Rest are all same default scheme of dark gray
            
        case .priority:
            result = UIColor(red: 255/255, green: 123/255, blue: 5/255, alpha: 1)
            break
        case .cooperate:
            result = UIColor(red: 27/255, green: 221/255, blue: 23/255, alpha: 1)
            break
            
        default:
            result = UIColor(red: 245/255, green: 162/255, blue: 25/255, alpha: 1)
            break
        }
        
        return result
    }
    
}
extension UIImage {
    
    func isEqualToImage(image: UIImage) -> Bool {
        let data1: NSData = UIImagePNGRepresentation(self)! as NSData
        let data2: NSData = UIImagePNGRepresentation(image)! as NSData
        return data1.isEqual(data2)
    }
    
}

extension Double
{
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func roundedStringValue () -> String
    {
        return String(format: "%.4f", self)
    }
    
    func twoDecimalValue() -> String
    {
        return String(format: "%.2f", self)
    }
}


extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        if let swRevealController = controller as? SWRevealViewController
        {
            return topViewController(controller: swRevealController.frontViewController)
        }
        return controller
    }
    
}

extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension String {
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijkmnpqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    func isValidEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func trimmed() -> String
    {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func length() -> Int
    {
        return self.characters.count
    }
}
