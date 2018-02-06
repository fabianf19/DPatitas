//
//  AceptWalkViewController.swift
//  DPatitas
//
//  Created by Fabian Fuenmayor Macbook Pro on 2/6/18.
//  Copyright © 2018 FabianFuenmayor. All rights reserved.
//

import UIKit
import SwiftyJSON

class AcceptWalkViewController: UIViewController, RequestManagerDelegate {
    
    var walk : JSON!
    
    var request_manager : RequestManager!
    var should_continue : Bool = false
    
    @IBOutlet weak var lbl_name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        request_manager = RequestManager(session : "1010211109")
        request_manager.delegate = self

        self.lbl_name.text = walk["dog"]["name"].string
        // Do any additional setup after loading the view.
    }
    
    func finishPassing(object: JSON) {
        if (object["action"].string == "assigned_walk"){
            self.should_continue = true
            performSegue(withIdentifier: "assigned", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func solicitWalk(_ sender: Any) {
        let data : JSON = [
            "action" : "assign_walk",
            "who" : self.request_manager.session,
            "data" : [
                "walk_id" : self.walk["walk_id"].string!,
                "user_id" : self.walk["user_id"].string!,
                "dog_id" : self.walk["dog"]["id"]
            ]
        ]

        let json_string = data.rawString()
        self.request_manager.send_data(text: json_string!)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return self.should_continue
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destination : StartWalkViewController = segue.destination as! StartWalkViewController
        destination.walk = self.walk
    }

}
