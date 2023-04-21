//
//  WeatherVCViewModel.swift
//  WeatherAppDemo
//
//  Created by Shilpa Brahme on 19/04/23.
//

import Foundation
import CoreLocation

enum TableSections: Int, CaseIterable {
    case TimeAndCity = 0
    case CurrentTemperature = 1
    case FeelsLike = 2
    case MinMaxTemperature = 3
}

class WeatherVCViewModel {
    var dataArray: [CellDataModel]?
    var selectedCityCoordinates = Coord()
    var selectedCityName: String?
    var selectedCityNameOnSearchBar: String?
    var hasLastSavedCity: Bool =  false
    var hasError: Bool =  false
    var hasLocationPermission = false
    
    
    init(dataArray: [CellDataModel]? = nil, selectedCityCoordinates: Coord = Coord() , selectedCityName: String? = nil, hasLastSavedCity: Bool = false) {
        self.dataArray = dataArray
        self.selectedCityCoordinates = selectedCityCoordinates
        self.selectedCityName = selectedCityName
        self.retreivePreviousCity()
        self.hasLastSavedCity = self.hasPreviousCity()
    }
    
    func getNumberOfSectionsInTable() -> Int {
        var count = 0
        if self.hasError {
            count = 1
        } else {
            count =  self.dataArray?.count ?? 0
        }
        return count
    }
    
    func getNumberOfRowsInTable(section: Int) -> Int {
        return 1
    }
    
    func getRowHeightForSection(section: Int) -> CGFloat {
        switch section {
            case TableSections.TimeAndCity.rawValue:
            if self.hasError {
                return 150
            }
            return 90
            
        
        case TableSections.FeelsLike.rawValue, TableSections.MinMaxTemperature.rawValue:
            return 30
            
            default :
            return 70
        }
    }
    
    //MARK: - location update
    func updateLocation(location:CLLocation?){
        self.selectedCityCoordinates = Coord.init()
        self.selectedCityCoordinates.lon = location?.coordinate.longitude
        self.selectedCityCoordinates.lat = location?.coordinate.latitude
        self.hasLocationPermission = true
    }
    
    //MARK: - weather manager
    
    func getWeatherData(cityName: String?, networkHandler: WeatherManager? = WeatherManager(), completionHandler: @escaping ParsedDataReturnType<Any>) {
        weak var weakSelf = self
        networkHandler?.fetchWeatherData(cityName: cityName, networkManager: networkHandler) { parsedDictionary, Error in
            if Error == nil {
                if let dataModel = parsedDictionary as? WeatherData {
                    print(dataModel as Any)
                    weakSelf?.presentDataDataModel(dataModel: dataModel)
                    completionHandler(dataModel, Error)
                } else {
                    self.hasError = true
                    completionHandler(nil, Error)
                }
            } else {
                self.hasError = true
                completionHandler(nil, Error)
            }
        }
    }
    
    func getWeatherDataFromCoordinates(coordinates: Coord?, networkHandler: WeatherManager? = WeatherManager(), completionHandler: @escaping ParsedDataReturnType<Any>) {
        self.hasError = false
        weak var weakSelf = self
        networkHandler?.fetchWeatherDataFromCoordinates(coordinates: coordinates, networkManager: networkHandler) { parsedDictionary, Error in
            if Error == nil {
                if let dataModel = parsedDictionary as? WeatherData {
                    print(dataModel as Any)
                    weakSelf?.presentDataDataModel(dataModel: dataModel)
                    completionHandler(dataModel, Error)
                } else {
                    self.hasError = true
                    completionHandler(nil, Error)
                }
                
            } else {
                self.hasError = true
                completionHandler(nil, Error)
            }
        }
    }
    
    func getGeoCoordinates(cityName: String?, networkHandler: CoordinatesAPIManager? = CoordinatesAPIManager(), completionHandler: @escaping ParsedDataReturnType<Any>) {
       // weak var weakSelf = self
        self.hasError = false
        networkHandler?.fetchCoordinatesFor(cityName: cityName, networkManager: networkHandler) { parsedDictionary, Error in
            if Error == nil {
                if let dataModel = parsedDictionary as? Coord {
                    print(dataModel as Coord)
                    completionHandler(dataModel, Error)
                    self.hasError = false
                } else {
                    self.hasError = true
                    completionHandler(nil, Error)
                }
            } else {
                self.hasError = true
                completionHandler(nil, Error)
            }
        }
    }
    
    //MARK: - prepare & present data
    
    func presentError <T>(error: T?) {
        self.resetData()
        self.hasError = true
        self.dataArray?.append(self.prepareErrorData(error: error))
    }
    
    func prepareErrorData <T>(error: T?) -> CellDataModel {
        var viewModel = CellWithImageAndLabelDataModel()
        var customError = error as? CustomError
        if let validError = customError?.localizedCustomError {
            viewModel.text = validError.rawValue
        } else {
            let defaultError = error as? Error
            viewModel.text = defaultError?.localizedDescription
        }
        return viewModel
    }
    
    func presentDataDataModel(dataModel: WeatherData) {
        self.resetData()
        self.selectedCityName = dataModel.name
        self.dataArray?.append(self.prepareDataForTimeAndCity(dataModel: dataModel))
        self.dataArray?.append(self.prepareDataForTemperature(dataModel: dataModel))
        self.dataArray?.append(self.prepareDataForFeelsLike(dataModel: dataModel))
        self.dataArray?.append(self.prepareDataForSunriseSunset(dataModel: dataModel))
    }
    
    func prepareDataForTimeAndCity(dataModel: WeatherData) -> CellDataModel {
        var viewModel = CellWithVerticalLabelDataModel()
        viewModel.textAtTop = Helper.getDayDateTime(format: DateTimeConstants.DAY_DATE_TIME_FORMAT, unixTimeStamp:dataModel.dt ?? 0, timezone: dataModel.timezone ?? 0)
        viewModel.textAtBottom = "\(String(describing: dataModel.name ?? ""))" + ", " + "\(dataModel.sys?.country ?? "")"
        return viewModel
    }
    
    func prepareDataForTemperature(dataModel: WeatherData) -> CellDataModel {
        var viewModel = CellWithImageAndLabelDataModel()
        if let iconName = dataModel.weather?[0].icon {
            viewModel.imageURL = APIEndPoints.getEndPointForWeatherIcon(icon: iconName)
        }
        viewModel.conditionName = dataModel.weather?[0].conditionName
        viewModel.text = "\(String(describing: dataModel.mainData?.temp ?? 0))".addCelciusSymbol()
        return viewModel
    }
    
    func prepareDataForFeelsLike(dataModel: WeatherData) -> CellDataModel {
        var viewModel = CellWithHorizontalLabelsDataModel()
        if let dataModel = dataModel.weather?[0] {
            viewModel.textTrailing = String(describing: dataModel.description ?? "").capitalized
        }
        viewModel.titleLeading = StringConstants.feelsLike.rawValue
        viewModel.textLeading = "\(dataModel.mainData?.feels_like ?? 0)".addCelciusSymbol()
        return viewModel
    }
    
    func prepareDataForSunriseSunset(dataModel: WeatherData) -> CellDataModel {
        var viewModel = CellWithHorizontalLabelsDataModel()
        let sunrise = dataModel.sys?.sunrise
        let sunset = dataModel.sys?.sunset
       
        viewModel.titleLeading = StringConstants.sunrise.rawValue
        viewModel.textLeading = Helper.getDayDateTime(format: DateTimeConstants.TIME_FORMAT, unixTimeStamp: sunrise ?? 0, timezone: dataModel.timezone ?? 0)
        viewModel.titleTrailing = StringConstants.sunset.rawValue
        viewModel.textTrailing =  Helper.getDayDateTime(format: DateTimeConstants.TIME_FORMAT, unixTimeStamp: sunset ?? 0, timezone: dataModel.timezone ?? 0)
        return viewModel
    }
    
    func resetData() {
        self.hasError = false
        self.dataArray?.removeAll()
        self.dataArray = nil
        self.dataArray = []
    }
    //MARK: - save / retrive previous city
    
    func saveCity() {
        let dataHandler = DataManager()
        dataHandler.saveCityNameToPlist(cityName: self.selectedCityName ?? "")
        dataHandler.saveCityNameAsOnSearchBar(cityName: self.selectedCityNameOnSearchBar ?? "")
        
    }
    
    func retreivePreviousCity() {
        let dataHandler = DataManager()
        self.selectedCityName = dataHandler.getPreviousCityName()
        self.selectedCityNameOnSearchBar = dataHandler.getPreviousCityNameAsOnSearchBar()
    }
    
    func hasPreviousCity() -> Bool {
        if self.selectedCityName == nil || self.selectedCityName?.count == 0 {
            return false
        }
        return true
    }
}
