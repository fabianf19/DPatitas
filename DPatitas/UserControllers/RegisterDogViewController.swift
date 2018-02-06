//
//  RegisterDogViewController.swift
//  DPatitas
//
//  Created by Fabian Fuenmayor Macbook Pro on 2/5/18.
//  Copyright © 2018 FabianFuenmayor. All rights reserved.
//

import Foundation
import UIKit
import SwiftWebSocket
import SwiftyJSON

protocol VCFinalDelegate {
    func finishPassing(dog: JSON)
}

class RegisterDogViewController: UIViewController, RequestManagerDelegate {
    
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_edad: UITextField!
    @IBOutlet weak var txt_raza: UITextField!
    
    var delegate: VCFinalDelegate?
    var dict : JSON!
    
    var request_manager : RequestManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        request_manager = RequestManager(session : "1020794398")
        request_manager.delegate = self
    }
    
    func finishPassing(object: JSON) {
        self.dict["dog"] = object["data"]
        self.delegate?.finishPassing(dog: self.dict)
        self.performSegue(withIdentifier: "back", sender: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.request_manager.closeSocket()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register_dog(_ sender: Any) {
        let name = txt_name.text
        let edad = txt_edad.text
        let raza = txt_raza.text
        
        self.dict = [
            "action" : "register_dog",
            "who" : "1020794398",
            "data" : [
                "name" : name!,
                "age" : edad!,
                "race" : raza!
                ]
            ]
        
        let json_string = JSON(self.dict).rawString()
        print(json_string!)
        
        // Conectar con servidor y registrar el perro
//        self.ws.send(json_string)
        self.request_manager.send_data(text: json_string!)
    }
}
