//
//  Wind.swift
//  WeatherAppDemo
//
//  Created by Shilpa Brahme on 19/04/23.
//

struct Clouds : Codable {
	let all : Int?

	enum CodingKeys: String, CodingKey {

		case all = "all"
	}

//	init(from decoder: Decoder) throws {
//		let values = try decoder.container(keyedBy: CodingKeys.self)
//		all = try values.decodeIfPresent(Int.self, forKey: .all)
//	}

}
