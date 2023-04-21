//
//  WeatherAPIManager.swift
//  WeatherAppDemo
//
//  Created by Shilpa Brahme on 19/04/23.
//

import Foundation

struct WeatherManager: APIManagerProtocol {
   
    
    func fetchWeatherData(cityName: String?, networkManager:APIManagerProtocol?, completionHandler: @escaping ParsedDataReturnType<Any>) {
        
        if let validCityName = cityName {
            let finalEndPoint = self.getEndPoint(cityName: validCityName)
            networkManager?.sendRequest(endPoint:finalEndPoint , completionHandler:  { data, response, error in
                if error == nil {
                    let parsedData: Result<WeatherData?, CustomError> = JSONParser.parseJson(data: data)
                    switch parsedData {
                    case .success(let dataModel):
                        if dataModel == nil {
                            var customError = CustomError.init()
                            customError.localizedCustomError = ErrorMessages.weatherDataFailed
                        } else {
                            print("\n\n success!! data is as : \n\(String(describing: dataModel))\n\n")
                            completionHandler(dataModel, nil)
                        }
                        
                    case .failure(let parsingError):
                        print("\n\n @@@@ error data is as : \n\(parsingError)\n\n")
                        completionHandler(nil, parsingError)
                    }
                } else {
                    completionHandler(nil, error)
                } // end of if-else error
            })
        }
    }
    
    func getEndPoint(cityName: String) -> String {
        let finalEndPoint = "\(APIEndPoints.getEndPointForWeatherData())\(cityName)"
        return finalEndPoint
    }
    
    func fetchWeatherDataFromCoordinates(coordinates: Coord?, networkManager:APIManagerProtocol?, completionHandler: @escaping ParsedDataReturnType<Any>) {
        
        if let validCityLat = coordinates?.lat, let validCityLong = coordinates?.lon, let validCoord = coordinates {
            let finalEndPoint = APIEndPoints.getEndPointForWeatherDataWithCoordinates(coordinates: validCoord)
            networkManager?.sendRequest(endPoint:finalEndPoint , completionHandler:  { data, response, error in
                if error == nil {
                    let parsedData: Result<WeatherData?, CustomError> = JSONParser.parseJson(data: data)
                    switch parsedData {
                    case .success(let dataModel):
                        if dataModel == nil {
                            var customError = CustomError.init()
                            customError.localizedCustomError = ErrorMessages.weatherDataFailed
                            completionHandler(nil, customError)
                        } else {
                            print("\n\n success!! data is as : \n\(String(describing: dataModel))\n\n")
                            completionHandler(dataModel, nil)
                        }
                     
                    case .failure(let parsingError):
                        print("\n\n @@@@ error data is as : \n\(parsingError)\n\n")
                        completionHandler(nil, parsingError)
                    }
                    
                } else {
                    completionHandler(nil, error)
                } // end of if-else error
            })
        }
    }
    
}

