//
//  MapViewController.swift
//  MyContactList
//
//  Created by Amishi Patel on 4/1/25.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController , CLLocationManagerDelegate{
    @IBAction func findUser(_ sender: Any) {
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    @IBOutlet weak var findUser: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()

        locationManager.delegate = self

        locationManager.requestWhenInUseAuthorization()
    
    }


    
    


}
