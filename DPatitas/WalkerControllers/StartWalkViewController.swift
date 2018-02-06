//
//  StartWalkViewController.swift
//  DPatitas
//
//  Created by Fabian Fuenmayor Macbook Pro on 2/6/18.
//  Copyright © 2018 FabianFuenmayor. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftyJSON

class StartWalkViewController: UIViewController, CLLocationManagerDelegate, RequestManagerDelegate {
    
    var walk : JSON!

    @IBOutlet weak var mapview: MKMapView!
    var locationManager : CLLocationManager!
    
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
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.walk["geolocation"]["lat"].floatValue), longitude: CLLocationDegrees(self.walk["geolocation"]["lon"].floatValue))
        self.mapview.addAnnotation(annotation)
        self.mapview.showsUserLocation = true
    }
    
    func finishPassing(object: JSON) {
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapview.setRegion(region, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func startWalk(_ sender: Any) {
        let data : JSON = [
            "action" : "start_walk",
            "who" : self.request_manager.session,
            "data" : [
                "walk_id" : self.walk["walk_id"].string!,
                "user_id" : self.walk["user_id"].string!,
                "dog_id" : self.walk["dog"]["id"]
            ]
        ]
        
        let json_string = data.rawString()
        self.request_manager.send_data(text: json_string!)
        self.locationManager.stopUpdatingLocation()
        
        self.performSegue(withIdentifier: "finalizar", sender: self)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destination : EndWalkViewController = segue.destination as! EndWalkViewController
        destination.walk = self.walk
    }

}
