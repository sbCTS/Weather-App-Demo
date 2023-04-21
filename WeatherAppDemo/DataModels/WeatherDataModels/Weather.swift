//
//  Weather.swift
//  WeatherAppDemo
//
//  Created by Shilpa Brahme on 19/04/23.
//

struct Weather : Codable {
	var ID : Int
//    var conditionId: Int
    var main : String?
    var description : String?
    var icon : String?
//    var temperature: Double

    var iconURL: String {
        return String(format: APIEndPoints.getEndPointForWeatherIcon(icon: icon ?? ""))
    }

	enum CodingKeys: String, CodingKey {

		case ID = "id"
		case main = "main"
		case description = "description"
		case icon = "icon"
	}

//	init(from decoder: Decoder) throws {
//		let values = try decoder.container(keyedBy: CodingKeys.self)
//		id = try values.decodeIfPresent(Int.self, forKey: .id)
//		main = try values.decodeIfPresent(String.self, forKey: .main)
//		description = try values.decodeIfPresent(String.self, forKey: .description)
//		icon = try values.decodeIfPresent(String.self, forKey: .icon)
//	}
//
   
    
    var conditionName: String {
       // switch conditionId {
        switch ID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }

}
