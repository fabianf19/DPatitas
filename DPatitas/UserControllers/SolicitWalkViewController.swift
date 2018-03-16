//
//  SolicitWalkViewController.swift
//  DPatitas
//
//  Created by Fabian Fuenmayor Macbook Pro on 2/5/18.
//  Copyright © 2018 FabianFuenmayor. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftWebSocket
import MapKit
import CoreLocation

class SolicitWalkViewController: UIViewController, CLLocationManagerDelegate, RequestManagerDelegate {
    var locationManager : CLLocationManager!
    var dog : JSON!
    var ws : WebSocket!
    
    var location : CLLocationCoordinate2D!
    var request_manager : RequestManager!
    
    var should_continue : Bool = false

    @IBOutlet weak var lbl_name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        request_manager = RequestManager(session : "1020794398")
        request_manager.delegate = self
        
        lbl_name.text = dog["nombre"].string
        
        self.locationManager = CLLocationManager()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.request_manager.closeSocket()
    }
    
    func finishPassing(object: JSON) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.location = locValue
    }

    @IBAction func solicit_walk(_ sender: Any) {
        
        if (self.location == nil){
            
            let alert = UIAlertController(title: "Atención", message: "No hay ubicación", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        var session = ""
        let usuario_string = UserDefaults.standard.string(forKey: "USUARIO")
        if let data = usuario_string!.data(using: .utf8) {
            if let usuario = try? JSON(data: data) {
                session = usuario["cedula"].stringValue
            }
        }
        
        let data : JSON = [
            "who" : session,
            "action" : "solicit_walk",
            "data" : [
                "dog_id" : self.dog["id"].stringValue,
                "location" : [
                    "lat" : self.location.latitude.description,
                    "lon" : self.location.longitude.description
                ]
            ]
        ]
        
        let alert = UIAlertController(title: "Atención", message: "Paseo publicado!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
        
        let json_string = JSON(data).rawString()
        self.request_manager.send_data(text: json_string!)
        
        self.locationManager.stopUpdatingLocation()
        
        self.should_continue = true
        self.performSegue(withIdentifier: "waiting", sender: self)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("df")
    }

}
