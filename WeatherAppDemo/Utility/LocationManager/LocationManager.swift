//
//  LocationManager.swift
//  WeatherAppDemo
//
//  Created by Shilpa Brahme on 20/04/23.
//

import Foundation
import MapKit

typealias LocationClosure = ((_ location:CLLocation?,_ error: NSError?)->Void)

final class LocationManager: NSObject {
    
    var locationAccuracy = kCLLocationAccuracyBest
 
    private var locationCompletionHandler: LocationClosure?
    private var locationManager:CLLocationManager?
    private var lastLocation:CLLocation?
    
    static let shared: LocationManager = {
        let instance = LocationManager()
        return instance
    }()
    
    private override init() {}

    deinit {
        destroyLocationManager()
    }
    
    private func setupLocationManager() {
        if locationManager != nil {
            if #available(iOS 14.0, *) {
                self.check(status: locationManager?.authorizationStatus)
            } else {
                self.check(status: CLLocationManager.authorizationStatus())
                // Fallback on earlier versions
            }
            return
        }
        //Setting of location manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = locationAccuracy
        if #available(iOS 14.0, *) {
            self.check(status: locationManager?.authorizationStatus)
        } else {
            self.check(status: CLLocationManager.authorizationStatus())
        }
    }
    
    private func destroyLocationManager() {
        locationManager?.delegate = nil
        locationManager = nil
        lastLocation = nil
    }
    
    @objc private func sendLocation() {
        guard let _ = lastLocation else {
            self.didComplete(location: nil,error: NSError(
                domain: self.classForCoder.description(),
                code:Int(CLAuthorizationStatus.denied.rawValue),
                userInfo:
                [NSLocalizedDescriptionKey:LocationErrors.notFetched.rawValue,
                 NSLocalizedFailureReasonErrorKey:LocationErrors.notFetched.rawValue,
                 NSLocalizedRecoverySuggestionErrorKey:LocationErrors.notFetched.rawValue]))
            lastLocation = nil
            return
        }
        self.didComplete(location: lastLocation,error: nil)
        lastLocation = nil
    }
    

    func isLocationEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    func getLocation(completionHandler:@escaping LocationClosure) {
        
        //Resetting last location
        lastLocation = nil
        
        self.locationCompletionHandler = completionHandler
        
        setupLocationManager()
    }
    
    //MARK:- Final closure/callback
    private func didComplete(location: CLLocation?,error: NSError?) {
        locationManager?.stopUpdatingLocation()
        locationCompletionHandler?(location,error)
        locationManager?.delegate = nil
        locationManager = nil
    }
    
    private func check(status: CLAuthorizationStatus?) {
        guard let status = status else { return }
        switch status {
            
        case .authorizedWhenInUse,.authorizedAlways:
            self.locationManager?.startUpdatingLocation()
            
        case .denied:
            let deniedError = NSError(
                domain: self.classForCoder.description(),
                code:Int(CLAuthorizationStatus.denied.rawValue),
                userInfo:
                [NSLocalizedDescriptionKey:LocationErrors.denied.rawValue,
                 NSLocalizedFailureReasonErrorKey:LocationErrors.denied.rawValue,
                 NSLocalizedRecoverySuggestionErrorKey:LocationErrors.denied.rawValue])
            
            didComplete(location: nil,error: deniedError)
            
        case .restricted:
            didComplete(location: nil,error: NSError(
                domain: self.classForCoder.description(),
                code:Int(CLAuthorizationStatus.restricted.rawValue),
                userInfo: nil))
            
        case .notDetermined:
            self.locationManager?.requestWhenInUseAuthorization()
            
        @unknown default:
                didComplete(location: nil,error: NSError(
                domain: self.classForCoder.description(),
                code:Int(CLAuthorizationStatus.denied.rawValue),
                userInfo:
                [NSLocalizedDescriptionKey:LocationErrors.unknown.rawValue,
                 NSLocalizedFailureReasonErrorKey:LocationErrors.unknown.rawValue,
                 NSLocalizedRecoverySuggestionErrorKey:LocationErrors.unknown.rawValue]))
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    //MARK:- CLLocationManager Delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           lastLocation = locations.last
           if let location = locations.last {
               let locationAge = -(location.timestamp.timeIntervalSinceNow)
               if (locationAge > 5.0) {
                   print("old location \(location)")
                   return
               }
               if location.horizontalAccuracy < 0 {
                   self.locationManager?.stopUpdatingLocation()
                   self.locationManager?.startUpdatingLocation()
                   return
               }
               self.sendLocation()
           }
       }
       
       func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
           self.check(status: status)
       }
       
       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print(error.localizedDescription)
           self.didComplete(location: nil, error: error as NSError?)
       }
       
}
