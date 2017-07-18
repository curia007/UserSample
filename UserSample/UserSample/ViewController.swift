//
//  ViewController.swift
//  UserSample
//
//  Created by Carmelo Uria on 7/17/17.
//  Copyright © 2017 Carmelo Uria. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    
    var activeField: UITextField?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTapped()
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        addressTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        zipCodeTextField.delegate = self
        countryTextField.delegate = self
        
        registerForKeyboardNotifications()

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

    override func viewDidDisappear(_ animated: Bool)
    {
        deregisterFromKeyboardNotifications()
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
    
    // MARK: - Keyboard functions
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField
        {
            nextField.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
}

