//
//  Connector.swift
//  DPatitas
//
//  Created by Felipe Macbook Pro on 3/15/18.
//  Copyright © 2018 FabianFuenmayor. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Connector{
    
    var URL = "http://a69ebf42.ngrok.io"
    
    init(){
        
    }
    
    func doGet(url : String, completion: @escaping (_ result: JSON)->()){
        Alamofire.request(URL + url).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
                
                let swifty_json = JSON(json)
                
                completion(swifty_json)
            }
        }
    }
    
    func doPost(url : String, params: [String : String], completion: @escaping (_ result: JSON)->()){
        
        Alamofire.request(URL + url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
                
                let swifty_json = JSON(json)
                
                completion(swifty_json)
            }
        }
    }
}
