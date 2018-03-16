//
//  RequestManager.swift
//  DPatitas
//
//  Created by Fabian Fuenmayor Macbook Pro on 2/5/18.
//  Copyright © 2018 FabianFuenmayor. All rights reserved.
//

import Foundation
import SwiftWebSocket
import SwiftyJSON

protocol RequestManagerDelegate  {
    func finishPassing(object: JSON)
}

class RequestManager : WebSocketDelegate {
    
    let URL = "http://a69ebf42.ngrok.io"
    var session = "1020794398"
    var ws : WebSocket!
    
    var delegate : RequestManagerDelegate?
    
    init(session : String) {
        self.ws = WebSocket(URL)
        self.ws.delegate = self
        
        self.session = session
    }
    
    func webSocketOpen() {
        print("opened")
    }
    
    func webSocketClose(_ code: Int, reason: String, wasClean: Bool) {
        print("close")
    }
    
    func getSession() -> String{
        let usuario_string = UserDefaults.standard.string(forKey: "USUARIO")
        if let data = usuario_string!.data(using: .utf8) {
            if let usuario = try? JSON(data: data) {
                return usuario["cedula"].stringValue
            }
        }
        return "1020794398"
    }
    
    func webSocketMessageText(_ text: String) {
        print(text)
        let session = self.getSession()
        print(session)
        
        if let dataFromString = text.data(using: .utf8, allowLossyConversion: false) {
            do{
                let json = try JSON(data: dataFromString)
                if (json["who"].string == session){
                    self.delegate?.finishPassing(object: json)
                }
            } catch {
                
            }
        }
    }
    
    func send_data(text : String){
        print("Sending data \(text)")
        self.ws.send(text)
    }
    
    func webSocketError(_ error: NSError) {
        print("error \(error)")
    }
    
    func closeSocket(){
        self.ws.close()
    }
    
}
