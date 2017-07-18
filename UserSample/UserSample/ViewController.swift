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
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var resultsTextView: UITextView!
    
    @IBOutlet weak var submitButton: UIButton!
 
    var json: [Any] = []
    var coordinate : [AnyHashable : Any] = [:]
    var address : [AnyHashable : Any] = [:]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: LOCATION_ADDRESS_RETRIEVED), object: nil, queue: OperationQueue.main) { (notification) in
            let placemark: CLPlacemark = notification.object as! CLPlacemark
            debugPrint("[\(#function)] placemark: \(placemark)")
            
            let locationProcessor: LocationProcessor = (UIApplication.shared.delegate as! AppDelegate).locationProcessor
            locationProcessor.stopProcessor()
            
            guard let addressDictionary: [AnyHashable : Any] = placemark.addressDictionary else {
                // enable text fields and start location processor
                
                self.addressTextField.isEnabled = true
                self.cityTextField.isEnabled = true
                self.stateTextField.isEnabled = true
                self.zipCodeTextField.isEnabled = true
                self.countryTextField.isEnabled = true
                
                return
            }
            
            self.address = addressDictionary
            
            self.coordinate = ["latitude" : placemark.location!.coordinate.latitude,
                          "longitude" : placemark.location!.coordinate.longitude]
         
            self.addressTextField.text = addressDictionary["Street"] as? String
            self.cityTextField.text = addressDictionary["City"] as? String
            self.stateTextField.text = addressDictionary["State"] as? String
            self.zipCodeTextField.text = addressDictionary["ZIP"] as? String
            self.countryTextField.text = addressDictionary["Country"] as? String
            
            self.submitButton.isEnabled = true
            
        }

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

    // MAKRK: - Action functions
    
    @IBAction func submitAction(_ sender: Any)
    {
        let jsonProcessor: JSONProcessor = (UIApplication.shared.delegate as! AppDelegate).jsonProcessor
        
        let user: [String : Any] = ["firstName" : firstNameTextField.text ?? " ",
                                    "lastName" : lastNameTextField.text ?? " ",
                                    "coordinate" : coordinate,
                                    "addressDictionary" : address]
        json = [user]
        
        guard let jsonData: Data = jsonProcessor.generateJSON(json) else {
            debugPrint("[\(#function)] JSON Data is nil")
            return
        }
        
        let results : String = String(data: jsonData, encoding: .utf8)!
        debugPrint("[\(#function)] results: \(results)")
        
        resultsTextView.backgroundColor = UIColor.green
        resultsTextView.alpha = 0.50
        resultsTextView.text = results
    }
}

