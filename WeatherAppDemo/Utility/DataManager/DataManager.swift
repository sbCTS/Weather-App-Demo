//
//  DataManager.swift
//  WeatherAppDemo
//
//  Created by Shilpa Brahme on 20/04/23.
//

import Foundation

struct DataManager {
    
    func saveCityNameToPlist(cityName: String) {
        let storage = UserDefaultsStorage.init(data: cityName, key: UserDefaultKeys.previousCityName.rawValue)
        storage.saveData()
    }
    
    func getPreviousCityName() -> String? {
        let storage = UserDefaultsStorage.init(data: "", key: UserDefaultKeys.previousCityName.rawValue)
        let abc = storage.getData()
        return abc
    }
    
    func saveCityNameAsOnSearchBar(cityName: String) {
        let storage = UserDefaultsStorage.init(data: cityName, key: UserDefaultKeys.previousCityNameAsOnSearchbar.rawValue)
        storage.saveData()
    }
    
    func getPreviousCityNameAsOnSearchBar() -> String? {
        let storage = UserDefaultsStorage.init(data: "", key: UserDefaultKeys.previousCityNameAsOnSearchbar.rawValue)
        let abc = storage.getData()
        return abc
    }
}


class UserDefaultsStorage <T: Codable> {
    private let keyForData: String
    private let dataToBeSaved: T?
    private let userDefaults = UserDefaults.standard

    init (data: T? = nil, key: String) {
        self.dataToBeSaved = data
        self.keyForData = key
    }

    func getData() -> T? {
        guard let data = userDefaults.data(forKey: self.keyForData) else {
            return "" as? T
        }
        let value = try? JSONDecoder().decode(T.self, from: data)
        return value ?? "" as? T
    }

    func saveData() {
        let data = try? JSONEncoder().encode(self.dataToBeSaved)
        userDefaults.set(data, forKey: self.keyForData)
    }

}
