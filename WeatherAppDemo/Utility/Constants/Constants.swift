//
//  Constants.swift
//  WeatherAppDemo
//
//  Created by Shilpa Brahme on 19/04/23.
//

import Foundation

struct NetworkConstants {
    static let APIKey = "fed04244794a9755b2c9c07d104186c4"
}

struct URLConstants {
    static let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid="
    static let imageIconBaseURL = "https://openweathermap.org/img/wn/"
    static let geoCoordinatesURL = "http://api.openweathermap.org/geo/1.0/direct?appid="
    
    // http://api.openweathermap.org/geo/1.0/direct?appid=fed04244794a9755b2c9c07d104186c4&q=London&limit=1
    // https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=fed04244794a9755b2c9c07d104186c4
    
}

struct URLParamaters {
    static let cityNameParameter = "&q="
    static let unitsParameter = "&units="
    static let unitsParameterValue = "metric"
    static let iconParameter = "@2x.png"
    static let limitParameter = "&limit="
    static let limitParameterValue = "1"
    static let latitudeParameter = "&lat="
    static let longitudeParameter = "&lon="
}


struct APIEndPoints {
    static func getEndPointForWeatherData() -> String {
       return URLConstants.baseURL + NetworkConstants.APIKey + URLParamaters.unitsParameter + URLParamaters.unitsParameterValue + URLParamaters.cityNameParameter
    }
    
    static func getEndPointForWeatherDataWithCoordinates(coordinates: Coord) -> String {
        return URLConstants.baseURL + NetworkConstants.APIKey + URLParamaters.latitudeParameter + String(format: "%.4f", coordinates.lat ?? 0) +
        URLParamaters.longitudeParameter + String(format: "%.4f", coordinates.lon ?? 0) + URLParamaters.unitsParameter + URLParamaters.unitsParameterValue
    }
    
    static func getEndPointForWeatherIcon(icon:String) -> String {
         return URLConstants.imageIconBaseURL + icon + URLParamaters.iconParameter
    }
    
    static func getEndPointForCityCoordinates() -> String {
        return URLConstants.geoCoordinatesURL + NetworkConstants.APIKey + URLParamaters.limitParameter + URLParamaters.limitParameterValue + URLParamaters.cityNameParameter
    }
}

struct DateTimeConstants {
    static let DAY_DATE_TIME_FORMAT = "MMM dd, h:mm a" //"EEEE, MMM d, yyyy, h:mm a" //"E, d MMM YYYY h:mm a"
    static let TIME_FORMAT = "h:mm a"
    static let DEFAULT_TIME_ZONE = "UTC"
}
