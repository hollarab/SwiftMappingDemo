//
//  ViewController.swift
//  Mapper
//
//  Created by hollarab on 2/24/16.
//  Copyright © 2016 a. brooks hollar. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadDone", name: kLoadedNotification, object: nil)
        myMapView.delegate = self
        DataStore.sharedInstance.loadData()
    }


    func loadDone() {
        print("Retrieved \(DataStore.sharedInstance.earthquakes.count) events")
        
        for quake in DataStore.sharedInstance.earthquakes {
            let anotation = EarthquakeAnotation(earthquake: quake)
            myMapView.addAnnotation(anotation)
        }
    }
    
    
    let initialLocation = CLLocation(latitude: 36.5853, longitude: -118.032)
    let regionRadius: CLLocationDistance = 100000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        myMapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - location manager to authorize user location for Maps app
    var locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            myMapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
}


extension ViewController: MKMapViewDelegate {

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? EarthquakeAnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView?
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view?.canShowCallout = true
                view?.calloutOffset = CGPoint(x: -5, y: 5)
                view?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            }
                
            view?.pinTintColor = annotation.pinTintColor()
            return view!
        }
        return nil
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let location = view.annotation as? EarthquakeAnotation else {return}
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            myMapView.showsUserLocation = true
        }
    }
}