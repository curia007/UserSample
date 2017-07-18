//
//  LocationProcessor+Delegate.swift
//  UserSample
//
//  Created by Carmelo Uria on 7/17/17.
//  Copyright © 2017 Carmelo Uria. All rights reserved.
//

import UIKit
import CoreLocation

extension LocationProcessor
{
    //MARK:  - CLLocationManagerDelegate functions
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        debugPrint("[\(#function)] location count: \(locations.count)")
        
        // retrieve address information
        let geoCoder: CLGeocoder = CLGeocoder()
        
        for location : CLLocation in locations {
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if (error == nil)
                {
                    debugPrint("[\(#function)] placemark count: \(placemarks!.count))")
                    
                    let placemark: CLPlacemark = (placemarks?.first)!
                    
                    debugPrint("[\(#function)] \(String(describing: placemark.addressDictionary))")
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: LOCATION_ADDRESS_RETRIEVED), object: placemark)
                }
                else
                {
                    print(error ?? "Unable to find address")
                    
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        debugPrint("[\(#function)]")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
    {
        debugPrint("[\(#function)]")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        debugPrint("[\(#function)]")
        
    }

}
