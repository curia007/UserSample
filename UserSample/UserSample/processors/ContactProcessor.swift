//
//  ContactProcessor.swift
//  UserSample
//
//  Created by Carmelo Uria on 7/17/17.
//  Copyright © 2017 Carmelo Uria. All rights reserved.
//

import UIKit
import Contacts

class ContactProcessor
{
    fileprivate let contactStore: CNContactStore = CNContactStore()
    
    init()
    {
        requestForAccess { (isAuthorized) in
            debugPrint("[\(#function)] isAuthorized: \(isAuthorized)")
        }
    }
    
    func requestForAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
            
        case .denied, .notDetermined:
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async(execute: { () -> Void in
                            //let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            //self.showMessage(message)
                        })
                    }
                }
            })
            
        default:
            completionHandler(false)
        }
    }
    
    func retrieveContactsWithStore(store: CNContactStore)
    {
        do {
            let groups = try store.groups(matching: nil)
            let predicate = CNContact.predicateForContactsInGroup(withIdentifier: groups[0].identifier)
            //let predicate = CNContact.predicateForContactsMatchingName("John")
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactEmailAddressesKey] as [Any]
            
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
        
            debugPrint("[\(#function)] contact count: \(contacts.count)")
        }
        catch
        {
            print(error)
        }
    }
}
