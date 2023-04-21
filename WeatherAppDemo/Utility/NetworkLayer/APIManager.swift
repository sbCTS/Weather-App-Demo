//
//  APIManager.swift
//  WeatherAppDemo
//
//  Created by Shilpa Brahme on 19/04/23.
//

import Foundation

typealias WebserviceReturnType = (Data?, URLResponse?, Error?) -> Void
typealias ParsedDataReturnType <T> = (T?, T?) -> Void


protocol APIManagerProtocol: Any {
      
    func sendRequestWithConfiguration(endPoint: String?, parameters: [String:Any]?, httpMethod: String?,
                     completionHandler: @escaping (WebserviceReturnType))
    
   func sendRequest(endPoint: String?, completionHandler: @escaping(WebserviceReturnType))
}


extension APIManagerProtocol  {
    func sendRequestWithConfiguration(endPoint: String?, parameters: [String : Any]?, httpMethod: String?, completionHandler: @escaping (WebserviceReturnType)) {
        if let endPoint = endPoint, let endPointURL =  URL.init(string: endPoint) {
            print("\n\n\n end point : \(endPointURL) \n\n\n")
                let dataTaskForURL =  URLSession.shared.dataTask(with: endPointURL) { data, response, error in
                    completionHandler(data, response, error)
            }
            dataTaskForURL.resume()
        }
    }
    
    func sendRequest(endPoint: String?, completionHandler: @escaping (WebserviceReturnType)) {
        if let endPoint = endPoint, let endPointURL =  URL.init(string: endPoint) {
            print("\n\n\n end point : \(endPointURL) \n\n\n")
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: endPointURL, completionHandler: { data, response, error in
                completionHandler(data, response, error)
            })
            task.resume()
        }
    }
    
}
