//
//  WeatherViewController.swift
//  WeatherAppDemo
//


import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: WeatherVCViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.viewModel = WeatherVCViewModel()
        self.tableView.estimatedRowHeight = 90
       // self.tableView.rowHeight = 50
        self.registerCell()
        if (self.viewModel?.hasLastSavedCity == true) {
            self.searchBar.text = self.viewModel?.selectedCityNameOnSearchBar
            self.populateWeatherDataFromCityName()
        } else {
            self.showLocationPopup {
                if self.viewModel?.hasLocationPermission == true {
                    self.populateWeatherDataFromCoordinates(dataModel: self.viewModel?.selectedCityCoordinates ?? Coord())
                }
            }
        }
    }

    func registerCell() {
        self.tableView.register(UINib(nibName: CellWithVerticalLabels.className, bundle: nil), forCellReuseIdentifier: CellWithVerticalLabels.className)
        self.tableView.register(UINib(nibName: CellWithHorizontalLabels.className, bundle: nil), forCellReuseIdentifier: CellWithHorizontalLabels.className)
        self.tableView.register(UINib(nibName: CellWithImageAndLabel.className, bundle: nil), forCellReuseIdentifier: CellWithImageAndLabel.className)
        self.tableView.register(UINib(nibName: CellForError.className, bundle: nil), forCellReuseIdentifier: CellForError.className)
    }
    
    func alertMessage(message:String,buttonText:String,completionHandler:(()->())?) {
        let alert = UIAlertController(title: "Location", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonText, style: .default) { (action:UIAlertAction) in
            completionHandler?()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    //MARK: - location pop up
    func showLocationPopup(completionHandler :@escaping (() -> Void)) {
        LocationManager.shared.getLocation { (location:CLLocation?, error:NSError?) in
            
            if let error = error {
                self.alertMessage(message: error.localizedDescription, buttonText: "OK", completionHandler: nil)
                self.viewModel?.hasLocationPermission = false
                return
            }

            guard let location = location else {
                self.alertMessage(message: "Unable to fetch location", buttonText: "OK", completionHandler: nil)
                self.viewModel?.hasLocationPermission = false
                return
            }
            self.viewModel?.updateLocation(location: location)
            completionHandler()
        }
    }
    
    
    //MARK: - get coordiantes and weather data
    
    func populateWeatherDataFromCityName() {
        weak var weakSelf = self
        self.viewModel?.getGeoCoordinates(cityName: self.searchBar.text, completionHandler:{dataModel, error in
            if error == nil {
                weakSelf?.viewModel?.selectedCityCoordinates = dataModel as? Coord ?? Coord()
                weakSelf?.populateWeatherDataFromCoordinates(dataModel: dataModel as? Coord ?? Coord())
            } else {
                weakSelf?.showError(error: error)
            } // end of if-else error coordinates data
        })  // end of cooridnates block
    }
    
    func populateWeatherDataFromCoordinates(dataModel: Coord) {
        weak var weakSelf = self
        weakSelf?.viewModel?.getWeatherDataFromCoordinates(coordinates: dataModel, completionHandler:{_, error in
            if (error == nil) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if weakSelf?.searchBar.text?.count == 0 {
                        weakSelf?.searchBar.text = weakSelf?.viewModel?.selectedCityName
                    }
                    weakSelf?.viewModel?.selectedCityNameOnSearchBar = weakSelf?.searchBar.text
                    weakSelf?.viewModel?.saveCity()
                }
            } else {
                weakSelf?.showError(error: error )
            } // end of if-error weather data
        })  // end of weather data block
    }

    //MARK: - error handling
    func showError <T>(error: T?) {
        if let validError = error {
            self.viewModel?.presentError(error: validError)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
}

//MARK: - tableview datasource & delegate
extension WeatherViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel?.getNumberOfSectionsInTable() ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.getNumberOfRowsInTable(section: section) ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier = ""
        switch indexPath.section {
            case TableSections.TimeAndCity.rawValue:
            let cell = self.configureCellForSection(indexPath: indexPath)
            return cell as! UITableViewCell
               
            case TableSections.CurrentTemperature.rawValue:
                cellIdentifier = CellWithImageAndLabel.className
                let cell0 = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CellWithImageAndLabel ?? CellWithImageAndLabel()
                cell0.dataModel = self.viewModel?.dataArray?[indexPath.section] as? CellWithImageAndLabelDataModel
                return cell0
                
            default :
                cellIdentifier = CellWithHorizontalLabels.className
                let cell0 = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CellWithHorizontalLabels ?? CellWithHorizontalLabels()
                cell0.dataModel = self.viewModel?.dataArray?[indexPath.section] as? CellWithHorizontalLabelsDataModel
                return cell0
        }
    }
    
    func configureCellForSection(indexPath: IndexPath) -> Any {
        var cellIdentifier = ""
        if self.viewModel?.hasError == true {
            cellIdentifier = CellForError.className
            let cell0 = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CellForError ?? CellForError()
           cell0.dataModel = self.viewModel?.dataArray?[indexPath.section] as? CellWithImageAndLabelDataModel
            return cell0
        } else {
            cellIdentifier = CellWithVerticalLabels.className
            let cell0 = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CellWithVerticalLabels ?? CellWithVerticalLabels()
            cell0.dataModel = self.viewModel?.dataArray?[indexPath.section] as? CellWithVerticalLabelDataModel
            return cell0
        }
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.viewModel?.getRowHeightForSection(section: indexPath.section) ?? UITableView.automaticDimension
    }

}

//MARK: - searchar delegate
extension WeatherViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.populateWeatherDataFromCityName()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return text.containsOnlyAlphabetsAndWhitespace()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            self.viewModel?.resetData()
            self.tableView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
