//
//  WaitingViewController.swift
//  DPatitas
//
//  Created by Fabian Fuenmayor Macbook Pro on 2/5/18.
//  Copyright © 2018 FabianFuenmayor. All rights reserved.
//

import UIKit
import SwiftWebSocket
import SwiftyJSON

class WaitingViewController: UIViewController, RequestManagerDelegate {
    
    var request_manager : RequestManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        request_manager = RequestManager(session : "1020794398")
        request_manager.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func finishPassing(object: JSON) {
        if (object["action"].string == "assigned_walk"){
            self.performSegue(withIdentifier: "tomap", sender: self)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
