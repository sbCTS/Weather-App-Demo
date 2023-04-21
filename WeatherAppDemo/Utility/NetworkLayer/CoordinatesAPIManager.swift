//
//  CoordinatesAPIManager.swift
//  WeatherAppDemo
//
//  Created by Shilpa Brahme on 19/04/23.
//

import Foundation

// http://api.openweathermap.org/geo/1.0/direct?q=London&limit=1&appid=fed04244794a9755b2c9c07d104186c4

struct CoordinatesAPIManager: APIManagerProtocol {
    func fetchCoordinatesFor(cityName: String?, networkManager:APIManagerProtocol?, completionHandler: @escaping ParsedDataReturnType<Any>) {
        
        if let validCityName = cityName {
            let finalEndPoint = self.getEndPoint(cityName: validCityName)
            networkManager?.sendRequest(endPoint:finalEndPoint , completionHandler:  { data, response, error in
                if error == nil {
                    let parsedData: Result<[Coord]?, CustomError> = JSONParser.parseJson(data: data)
                    switch parsedData {
                    case .success(let dataModel):
                        print("\n\n success!! coordinates data is as : \n\(String(describing: dataModel))\n\n")
                        if dataModel?.isEmpty == true {
                            var customError = CustomError.init()
                            customError.localizedCustomError = ErrorMessages.coordinatesFailed
                            completionHandler(nil, customError)
                        } else {
                            completionHandler(dataModel?[0], nil)
                        }
                        
                    case .failure(let parsingError):
                        print("\n\n @@@@ error coordinates error is as : \n\(parsingError)\n\n")
                        completionHandler(nil, parsingError )
                    }
                } else {
                    completionHandler(nil, error )
                }// end of if error == nil
            })
        }
    }

    func getEndPoint(cityName: String) -> String {
        let cityNameEdited = cityName.replacingOccurrences(of: " ", with: "+")
        let finalEndPoint = "\(APIEndPoints.getEndPointForCityCoordinates())\(cityNameEdited)"
        return finalEndPoint
    }
}



