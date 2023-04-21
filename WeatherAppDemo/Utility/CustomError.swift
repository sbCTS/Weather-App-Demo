//
//  CustomError.swift
//  WeatherAppDemo
//
//  Created by Shilpa Brahme on 20/04/23.
//

import Foundation

struct CustomError: Error {
    var localizedCustomError: ErrorMessages?
}

//protocol CustomError: Error {
//    var localizedCustomError: ErrorMessages {get set}
//}

enum ErrorMessages: String {
    case genericError = "Unable to get Data.\nPlease try again."
    case coordinatesFailed = "Unable to get coordinates for this city.\nPlease enter a valid city name"
    case weatherDataFailed = "Unable to get weather data for this city.\nPlease enter a valid city name or please try again later."
    case noInternet = "No internet.\nPlease try again later."
    case noDataToParse = "No data to parse json"
}
