//
//  WeatherData.swift
//  WeatherAppDemo
//
//  Created by Shilpa Brahme on 19/04/23.
//

struct WeatherData : Codable {
	let coord : Coord?
	let weather : [Weather]?
	let base : String?
	let mainData : MainData?
	let visibility : Int?
	let wind : Wind?
	let rain : Rain?
	let clouds : Clouds?
	let dt : CUnsignedLongLong?
	let sys : Sys?
	let timezone : Int?
	let id : Int?
	let name : String?
	let cod : Int?

	enum CodingKeys: String, CodingKey {

		case coord = "coord"
		case weather = "weather"
		case base = "base"
		case mainData = "main"
		case visibility = "visibility"
		case wind = "wind"
		case rain = "rain"
		case clouds = "clouds"
		case dt = "dt"
		case sys = "sys"
		case timezone = "timezone"
		case id = "id"
		case name = "name"
		case cod = "cod"
	}
}
