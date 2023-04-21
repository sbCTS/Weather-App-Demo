//
//  Rain.swift
//  WeatherAppDemo
//
//  Created by Shilpa Brahme on 19/04/23.
//

struct Coord : Codable {
    var name: String?
	var lon : Double?
	var lat : Double?
    var country: String?

	enum CodingKeys: String, CodingKey {

		case lon = "lon"
		case lat = "lat"
        case name = "name"
        case country = "country"
	}

//	init(from decoder: Decoder) throws {
//		let values = try decoder.container(keyedBy: CodingKeys.self)
//		lon = try values.decodeIfPresent(Double.self, forKey: .lon)
//		lat = try values.decodeIfPresent(Double.self, forKey: .lat)
//        name = try values.decodeIfPresent(String.self, forKey: .name)
//        country = try values.decodeIfPresent(String.self, forKey: .country)
//	}

}

