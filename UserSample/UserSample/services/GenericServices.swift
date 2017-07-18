//
//  GenericServices.swift
//  UserSample
//
//  Created by Carmelo Uria on 7/18/17.
//  Copyright © 2017 Carmelo Uria. All rights reserved.
//

import UIKit

let PROCESSED_GENERIC_SERVICE_REQUEST: String = "PROCESSED_GENERIC_SERVICE_REQUEST"

class GenericServices: NSObject
{
    private let HOST: String = "https://sample.service.com/"
    
    private var session: URLSession?
    private var dataSessionTask: URLSessionDataTask?
    
    override public init()
    {
        super.init()
    }
    
    public func callService(_ data: Data)
    {
        let urlString : String = HOST 
        let url : URL = URL(string: urlString)!
        
        debugPrint("[\(#function)] url: \(url)")
        
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        
        //Note : Add the corresponding "Content-Type" and "Accept" header. In this example I had used the application/json.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        self.dataSessionTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            if (error == nil)
            {
                if (response != nil)
                {
                    let httpResponse: HTTPURLResponse = response as! HTTPURLResponse
                    
                    if (httpResponse.statusCode == 200)
                    {
                        debugPrint("[\(#function)] status code: \(httpResponse.statusCode)")
                        
                        if let urlContent = data
                        {
                            do
                            {
                                let jsonResult : Any = try JSONSerialization.jsonObject(with: urlContent, options:
                                    JSONSerialization.ReadingOptions.mutableContainers)
                                
                                debugPrint("[\(#function)] json: \(String(describing: jsonResult))")
                                
                                NotificationCenter.default.post(name: Notification.Name(rawValue: PROCESSED_GENERIC_SERVICE_REQUEST), object: jsonResult)
                                
                            }
                            catch
                            {
                                print("JSON Processing Failed")
                            }
                        }
                    }
                    else
                    {
                        debugPrint("[\(#function)] Service Call failure: status code: \(httpResponse.statusCode)")
                    }
                }
            }
            else
            {
                print("\(#function):: error: \(error?.localizedDescription ?? "Lotto Processing Error...")")
            }
        })
        
        self.dataSessionTask?.resume()
    }
    
}
