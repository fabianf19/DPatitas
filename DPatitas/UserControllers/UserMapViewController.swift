//
//  UserMapViewController.swift
//  DPatitas
//
//  Created by Fabian Fuenmayor Macbook Pro on 2/5/18.
//  Copyright © 2018 FabianFuenmayor. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftyJSON
import GoogleMaps

class UserMapViewController: UIViewController, RequestManagerDelegate {

    var points : [JSON?] = []
    
    var request_manager : RequestManager!
    var mapView : GMSMapView!
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: 4.60301193874758, longitude: -74.0646122849082, zoom: 13)
        self.mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        self.view = self.mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        request_manager = RequestManager(session : "1020794398")
        request_manager.delegate = self
        
//        let path = GMSMutablePath()
//        path.add(CLLocationCoordinate2D(latitude: 37.36, longitude: -122.0))
//        path.add(CLLocationCoordinate2D(latitude: 37.45, longitude: -122.0))
//        path.add(CLLocationCoordinate2D(latitude: 37.45, longitude: -122.2))
//        path.add(CLLocationCoordinate2D(latitude: 37.36, longitude: -122.2))
//        path.add(CLLocationCoordinate2D(latitude: 37.36, longitude: -122.0))
//
//        let rectangle = GMSPolyline(path: path)
//        rectangle.map = self.mapView

        // Do any additional setup after loading the view.
    }
    
    func draw_line(){
        let path = GMSMutablePath()
        
        for point in self.points {
            path.add(CLLocationCoordinate2D(latitude: CLLocationDegrees(point!["lat"].floatValue), longitude: CLLocationDegrees(point!["lon"].floatValue)))
        }
        
        let rectangle = GMSPolyline(path: path)
        rectangle.map = self.mapView
    }
    
    func finishPassing(object: JSON) {
        if (object["action"].string == "walk_points"){
            print(object)
            self.mapView.clear()
            
            let n_point : JSON = [
                "lat" : object["data"]["lat"].floatValue,
                "lon" : object["data"]["lon"].floatValue
            ]
            
            self.points.append(n_point)
            self.draw_line()
        }else if(object["action"].string == ""){
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
