//
//  EndWalkViewController.swift
//  DPatitas
//
//  Created by Fabian Fuenmayor Macbook Pro on 2/6/18.
//  Copyright © 2018 FabianFuenmayor. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftyJSON

class EndWalkViewController: UIViewController, CLLocationManagerDelegate, RequestManagerDelegate {
    
    var locationManager : CLLocationManager!
    var walk : JSON!
    var request_manager : RequestManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        request_manager = RequestManager(session : "1010211109")
        request_manager.delegate = self

        // Do any additional setup after loading the view.
        self.locationManager = CLLocationManager()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func finishPassing(object: JSON) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            // your code here
            self.locationManager.startUpdatingLocation()
        }
        
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        let data : JSON = [
            "action" : "send_location",
            "data" : [
                "walk_id": self.walk["walk_id"].string!,
                "dog_id": self.walk["dog"]["id"],
                "lat": "\(location.latitude)",
                "lon": "\(location.longitude)",
                "user_id" : self.walk["user_id"].string!
            ],
            "who" : self.request_manager.session
        ]
        
        let json_string = data.rawString()
        request_manager.send_data(text: json_string!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func endWalk(_ sender: Any) {
        self.locationManager.stopUpdatingLocation()
        self.request_manager.closeSocket()
        
        let data : JSON = [
            "action" : "end_walk"
        ]
        
        let json_string = data.rawString()
//        request_manager.send_data(text: json_string!)
        
        self.locationManager.stopUpdatingLocation()
        self.performSegue(withIdentifier: "towalks", sender: self)
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
