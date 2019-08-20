//
//  MapView.swift
//  342_Final_Project
//
//  Created by Hashaivione Edmundson on 12/2/18.
//  Copyright © 2018 Hashaivione Edmundson. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapView: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        MapView.delegate = self
        self.AddressLabel.numberOfLines = 0
        self.AddressLabel.adjustsFontSizeToFitWidth = true

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkLocationServices()
    }
   
    //IBOutlet declared
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var AddressLabel: UILabel!
    
    let locationMan = CLLocationManager()
    let regionInMeters: Double = 10000
    var previousLocation : CLLocation?
    
    
    //Setups location manager
    func setupLocationMan(){
        locationMan.delegate = self as CLLocationManagerDelegate
        locationMan.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    //Centers view on users location
    func centerViewOnUserLocation(){
        if let loc = locationMan.location?.coordinate{
            let reg = MKCoordinateRegion.init(center: loc, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            MapView.setRegion(reg, animated: true)
        }
    }
    
    //Checks to see if location services is enables
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationMan()
            checkLocationAuthorization()
        }else{
            let alert = UIAlertController(title: "Location Services is Disabled", message: "To use this feature, they must be on", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: DismissView))
            self.present(alert,animated: true,completion: nil)
        }
    }
    
    //Called if error with getting location
    func DismissView(alert: UIAlertAction!){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //Checks to see if app has access to location
    func checkLocationAuthorization(){
         let alert = UIAlertController(title: "Location Unavailable", message: "Allow location access to this app to be able to use this feature", preferredStyle: .alert)
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            MapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationMan.startUpdatingLocation()
            previousLocation = getCenterLoc(for: MapView)
            break;
        case .denied:
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: DismissView))
            self.present(alert,animated: true,completion: nil)
            break;
        case .notDetermined:
            locationMan.requestWhenInUseAuthorization()
            break;
        case .restricted:
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: DismissView))
            self.present(alert,animated: true,completion: nil)
            break;
        
        case .authorizedAlways:
            break;
        }
    }
    
    //Gets location
    func getCenterLoc(for mapView: MKMapView) -> CLLocation{
        let lat = MapView.centerCoordinate.latitude
        let long = MapView.centerCoordinate.longitude
        return CLLocation(latitude: lat, longitude: long)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationServices()
    }
    
    //Configues mapview with location
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLoc(for: MapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else {return}
        
        //wait
        guard center.distance(from: previousLocation) > 50 else {return}
        
        self.previousLocation = center
        
        //Reverses location to get address
        geoCoder.reverseGeocodeLocation(center) {[weak self] (placemarks,error) in
            guard let self = self else{ return}
            
            if let _ = error{
                return
            }
            
            guard let placemark = placemarks?.first else{
                return
            }
            
            //gets address
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let city = placemark.locality ?? ""
            let state = placemark.administrativeArea ?? ""
            let areacode = placemark.postalCode ?? ""
            
            DispatchQueue.main.async {
                self.AddressLabel.text = "\(streetNumber) \(streetName) \(city) ,\(state) \(areacode)"
            }
        }
    }
 

}
