//
//  NetworkManager.swift
//  NeighborhoodHttpApp
//
//  Created by Aqeel on 22/01/2018.
//  Copyright © 2018 yamsol. All rights reserved.
//

import Foundation

class NetworkManager : NSObject {
    
    static func getAPIWith(url : String, completion: @escaping ((_ success: Bool, _ message : String, _ data: AnyObject?) -> Void))
    {
       
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: url)!
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                completion(false, error!.localizedDescription, nil)
            } else {
 
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                    
                    var response = String()
                    
                    if let status = parsedData["status"] as? String {
                        response = status
                    }
                    
                    if let message = parsedData["message"] as? String {
                        response = response + " : " + message
                        completion(true, response , nil)
                    }
                    
                    if let userResponse = parsedData["data"] as? NSArray {
                        print(userResponse)
                        completion(true,"Success", userResponse)
                    }
                    
                    
                } catch let error as NSError {
                    print(error)
                    
                    completion(false, error.localizedDescription, nil)
                }
                
            }
        }
        task.resume()
    }
    
    static func postAPIWith(url : String, params : [String: Any], completion: @escaping ((_ success: Bool, _ message : String, _ data: AnyObject?) -> Void))
    {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                completion(false, error!.localizedDescription, nil)
            } else {
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                    print(parsedData)
                    
                    if let token = parsedData["token"] as? String {
                        completion(true,token, parsedData)
                        return;
                    }
                    
                    completion(true,"Token Nil", parsedData)
                
                } catch let error as NSError {
                    print(error)
                    
                    completion(false, error.localizedDescription, nil)
                }
                
            }
        }
        task.resume()
    }
    
    
}
