//
//  Rain.swift
//  WeatherAppDemo
//
//  Created by Shilpa Brahme on 19/04/23.
//

struct Rain : Codable {
	let oneHour : Double?

	enum CodingKeys: String, CodingKey {

		case oneHour = "1h"
	}

//	init(from decoder: Decoder) throws {
//		let values = try decoder.container(keyedBy: CodingKeys.self)
//		oneHour = try values.decodeIfPresent(Double.self, forKey: .oneHour)
//	}

}
