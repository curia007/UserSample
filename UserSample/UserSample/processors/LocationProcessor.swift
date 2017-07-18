//
//  LocationProcessor.swift
//  UserSample
//
//  Created by Carmelo Uria on 7/17/17.
//  Copyright © 2017 Carmelo Uria. All rights reserved.
//

import UIKit
import CoreLocation

public let LOCATION_ADDRESS_RETRIEVED: String = "LOCATION_ADDRESS_RETRIEVED"

class LocationProcessor : NSObject, CLLocationManagerDelegate
{

    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    
    let isLocationServicesEnabled: Bool = CLLocationManager.locationServicesEnabled()
    
    override init()
    {

        if (isLocationServicesEnabled)
        {
            // determine location
            let authorizationStatus:CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
            if ((authorizationStatus == .denied) ||
                (authorizationStatus == .restricted) ||
                (authorizationStatus == .notDetermined))
            {
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
        else
        {
        }
        
    }
    
    func startProcessor()
    {
        if (isLocationServicesEnabled)
        {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    
    func stopProcessor()
    {
        if (isLocationServicesEnabled)
        {
            locationManager.stopUpdatingLocation()
        }
    }

}
