//
//  MyLocationManager.swift
//  Neighbourhoods
//
//  Created by Aqeel  on 17/03/2017.
//  Copyright © 2017 Hanan. All rights reserved.
//

import UIKit
import CoreLocation

class MyLocationManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = MyLocationManager()
    
    fileprivate var locationManager : CLLocationManager!
    
    var lastSavedLocation : CLLocation?
    var savedLocationParameters = NSMutableArray()
    var isMonitoringLocation = false
    
    public enum locationAuth {
        
        case disabled
        case undetermined
        case denied
        case restricted
        case alwaysAuthorized
        case inUseAuthorized
        
        
        /// current status of the authorizations
        public static var status: locationAuth {
            guard CLLocationManager.locationServicesEnabled() else {
                return .disabled
            }
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:		return .undetermined
            case .denied:				return .denied
            case .restricted:			return .restricted
            case .authorizedAlways:		return .alwaysAuthorized
            case .authorizedWhenInUse:	return .inUseAuthorized
            }
        }
        
        /// Permission was granted by the user
        public static var isAuthorized: Bool {
            switch locationAuth.status {
            case .alwaysAuthorized, .inUseAuthorized:
                return true
            default:
                return false
            }
        }
    }
    
    func startLocationMonitoring(allowLocationInBackground : Bool)
    {
//        locationRequest = Location.getLocation(accuracy: .navigation, frequency: .continuous, success: { (request : LocationRequest, location : CLLocation) -> (Void) in
//            
//            self.lastLocation = location
//            
//            let data = ["location" : self.lastLocation]
//            NotificationCenter.default.post(name: .kUserLocationUpdated, object: nil, userInfo: data)
//
//            
//        }) { (request : LocationRequest, location : CLLocation?, error : Error) -> (Void) in
//            
//            if let previousLocation = location
//            {
//                let data = ["location" : previousLocation]
//                NotificationCenter.default.post(name: .kUserLocationUpdated, object: nil, userInfo: data)
//                
//            }
//        }
//        
//        locationRequest.minimumDistance = 10.0
        
        if (locationAuth.status == .disabled || locationAuth.status == .denied)
        {
            print("your location services are disabled. please activate them to best use the application")
            return;
        }
        else if (self.isMonitoringLocation == true)
        {
            return;
        }
        
        locationManager = CLLocationManager()
        locationManager.distanceFilter = 10.0
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = allowLocationInBackground
        
        isMonitoringLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while get location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations == nil
        {
            return;
        }
        
        if let userLocation = locations.last
        {
            lastSavedLocation = userLocation
            let data = ["location" : self.lastSavedLocation]
            NotificationCenter.default.post(name: .kDriverLocationUpdated, object: nil, userInfo: data)
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if (status == .authorizedAlways || status == .authorizedWhenInUse)
        {
           locationManager.startUpdatingLocation()
        }
    }
    
    func stopLocationMonitoring()
    {
        if (locationManager != nil)
        {
            locationManager.stopUpdatingLocation()
            self.isMonitoringLocation = false
        }
    }
    
    func restartLocationMonitoring(allowBackgroundLocationUpdates : Bool)
    {
        stopLocationMonitoring()
        startLocationMonitoring(allowLocationInBackground : allowBackgroundLocationUpdates)
    }
    
//    func appBecameActive()
//    {
//        let authStatus = locationAuth.status
//
//        switch authStatus {
//        case .inUseAuthorized, .alwaysAuthorized:
//            self.restartLocationMonitoring(allowBackgroundLocationUpdates: DataModel.shared.allowBackgroundLocationUpdates)
//            break
//        default:
//            // Do Nothing
//            break
//        }
//    }
    
    func appBecameActive()
    {
        let authStatus = locationAuth.status
        
        switch authStatus {
        case .inUseAuthorized, .alwaysAuthorized:
            self.restartLocationMonitoring(allowBackgroundLocationUpdates: DataModel.shared.allowBackgroundLocationUpdates)
            break
        case .disabled, .denied:
            // Do Nothing
            break
        default:
            self.restartLocationMonitoring(allowBackgroundLocationUpdates: DataModel.shared.allowBackgroundLocationUpdates)
            break
        }
    }
    
    
    
}

