//
//  DataStore.swift
//  Mapper
//
//  Created by hollarab on 2/24/16.
//  Copyright © 2016 a. brooks hollar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MapKit
import AddressBook
import Contacts

let kDateString = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

let smallQuakeListURL = NSURL(string: "https://aqueous-depths-77407.herokuapp.com/earthquakes.json")      // 100 Earthquakes
let largeQuakeListURL = NSURL(string: "https://earthquake-grapher.herokuapp.com/earthquakes.json")        // 10000 Earthquakes

struct Earthquake {
    var id:Int
    var long:Double
    var lat:Double
    var mag:Float
    var date:NSDate
    var place:String
}


class DataStore {
    static var sharedInstance = DataStore()
    var earthquakes = [Earthquake]()
    
    private var currentURL = smallQuakeListURL
    
    func loadData() {
        print("loading")
        earthquakes = [Earthquake]()
        Alamofire.request(.GET, currentURL!).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    for item in json.arrayValue {
                        let id = item["id"].intValue
                        let long = item["longitude"].doubleValue
                        let lat = item["latitude"].doubleValue
                        let mag = item["mag"].floatValue
                        let dateString = item["time"].stringValue
                        let place = item["place"].stringValue
                        
                        let date = self.dateFromString(dateString) ?? NSDate()
                        
                        self.earthquakes.append(Earthquake(id: id, long: long, lat: lat, mag: mag, date: date, place:place))
                    }
                }

                print("loaded \(self.earthquakes.count) events")
            case .Failure(let error):
                print(error)
            }
        }
    }

    
    func dateFromString(string:String) -> NSDate? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = kDateString
        return formatter.dateFromString(string)
    }
    
}