//
//  MapViewController.swift
//  MyContactList
//
//  Created by Amishi Patel on 4/1/25.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

class MapViewController: UIViewController , CLLocationManagerDelegate, MKMapViewDelegate{
    @IBOutlet weak var sgmtMapType: UISegmentedControl!
    
    @IBAction func mapTypeChanged(_ sender: Any) {
        switch sgmtMapType.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    var contacts:[Contact] = []
    @IBAction func findUser(_ sender: Any) {
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    @IBOutlet weak var findUser: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()

        locationManager.delegate = self

        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
    
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        var span = MKCoordinateSpan()
        span.latitudeDelta = 0.2
        span.longitudeDelta = 0.2
        let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        mapView.setRegion(viewRegion, animated: true)
        let mp = MapPoint(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        mp.title = "You"
        mp.subtitle = "Are Here"
        mapView.addAnnotation(mp)
    
    }
    override func viewWillAppear(_ animated: Bool)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Contact")
        var fetchedObjects: [NSManagedObject] = []
        do {
            fetchedObjects = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error) , \(error.userInfo)")
        }
        contacts = fetchedObjects as! [Contact]
        
        self.mapView.removeAnnotations(self.mapView.annotations)

        
        for contact in contacts {
            let address = "\(contact.streetAddress!), \(contact.city!),\(contact.state!)"
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                self.processAddressResponse(contact, withPlacemarks: placemarks, error: error)
            }
            
        }
    }
    
    private func processAddressResponse(_ contact: Contact, withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            print("Geocode Error: \(error)")
        } else {
            var bestMatch: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 {
                bestMatch = placemarks.first?.location
            }
            
            if let coordinate = bestMatch?.coordinate {
                let mp = MapPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
                mp.subtitle = contact.streetAddress
                mp.subtitle2 = contact.email
                mp.title = "\(contact.contactName ?? " ") \n \(mp.subtitle ?? " ") \n \(mp.subtitle2 ?? " ")"
                
                mapView.addAnnotation(mp)
            } else {
                print("Did not find matching locations")
            }
        }
    }

    
    


}
