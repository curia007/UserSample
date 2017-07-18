//
//  ViewController.swift
//  UserSample
//
//  Created by Carmelo Uria on 7/17/17.
//  Copyright © 2017 Carmelo Uria. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if (CLLocationManager.locationServicesEnabled() == false)
        {
            // create the alert
            let alert = UIAlertController(title: "Location Services", message: "Location Services is not Available.", preferredStyle: UIAlertControllerStyle.alert)
        
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }

    }

}

