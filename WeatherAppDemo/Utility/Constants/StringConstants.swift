//
//  StringConstants.swift
//  WeatherAppDemo
//
//  Created by Shilpa Brahme on 19/04/23.
//

import Foundation

enum WeatherConditions {
    case Thunderstorms
    case Drizzle
    case Rain
    case Snow
}

enum StringConstants: String {
    case sunrise = "Sunrise : "
    case sunset = "  Sunset : "
    case feelsLike = "Feels Like : "
    case celciusSymbol = "\u{00B0}"
}

enum UserDefaultKeys:String {
    case previousCityName = "cityName"
    case previousCityNameAsOnSearchbar = "cityNameAsOnSearchBar"
}

enum LocationErrors: String {
    case denied = "Locations are turned off. Please turn it on in Settings"
    case restricted = "Locations are restricted"
    case notDetermined = "Locations are not determined yet"
    case notFetched = "Unable to fetch location"
    case invalidLocation = "Invalid Location"
    case reverseGeocodingFailed = "Reverse Geocoding Failed"
    case unknown = "Some Unknown Error occurred"
}
