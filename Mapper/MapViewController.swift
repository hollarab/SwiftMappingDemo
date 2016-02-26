//
//  ViewController.swift
//  Mapper
//
//  Created by hollarab on 2/24/16.
//  Copyright © 2016 a. brooks hollar. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet var myLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataStore.sharedInstance.loadData()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    
    // MARK: - Inital Location
    let regionRadius: CLLocationDistance = 5_000_000                                // 5 Million Meters - underscores are convenience
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)   // Honalulu, CO
//    let initialLocation = CLLocation(latitude: 36.5853, longitude: -118.032)      // Westminster, CO


    
}

// MARK: - Navigation and Unwind seques
extension MapViewController {
    
    @IBAction func infoButtonTouched(sender:AnyObject) {
        performSegueWithIdentifier("Info", sender: self)
    }
    
    @IBAction func mapInfoDismissed(segue:UIStoryboardSegue) {
        print("unwind segues reached")
    }
}

