//
//  JSONParser.swift
//  WeatherAppDemo
//
//  Created by Shilpa Brahme on 19/04/23.
//

import Foundation

extension String : Error {
    
}

class JSONParser<T: Codable> {
    class func parseJson(data: Data?) -> Result<T?, CustomError> {
        var defaultError = CustomError.init()
        defaultError.localizedCustomError = ErrorMessages.genericError
        if let data = data {
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                return .success(result)
            } catch let error {
                return .failure(error as? CustomError ?? defaultError)
            }
        }
        defaultError.localizedCustomError = ErrorMessages.noDataToParse
        return .failure(defaultError)
    }
}

