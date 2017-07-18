//
//  JSONProcessor.swift
//  UserSample
//
//  Created by Carmelo Uria on 7/17/17.
//  Copyright © 2017 Carmelo Uria. All rights reserved.
//

import UIKit

class JSONProcessor
{
    init()
    {
        
    }
    
    func generateJSON(_ entities: [Any]) -> Data?
    {
        
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: entities, options: .prettyPrinted)
            return jsonData
        }
        catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
}
