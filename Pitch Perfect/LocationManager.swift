//
//  LocationManager.swift
//  Pitch Perfect
//
//  Created by Dheeraj Gembali on 11/12/14.
//  Copyright (c) 2014 Insanity. All rights reserved.
//

import Foundation
import CoreLocation

//private let _sharedManager = CLLocationManager()
//
//class LocationManager: CLLocationManager {
//    
//    class var sharedManager: CLLocationManager {
//        return _sharedManager
//    }
//
//}

//var instance: LocationManager?
//
//class LocationManager: CLLocationManager {
//    
//    class func sharedManager() -> LocationManager {
//        if instance == nil {
//            instance = LocationManager()
//        }
//        
//        return instance!
//    }
//}


//        if Static._sharedManager == nil {
//            Static._sharedManager = CLLocationManager()
//        }


class LocationManager {
    
    class var sharedManager: CLLocationManager {
        struct Static {
            static var _sharedManager: CLLocationManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static._sharedManager = CLLocationManager()
        }

        return Static._sharedManager!
    }

}



