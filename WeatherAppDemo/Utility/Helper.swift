//
//  Helper.swift
//  WeatherAppDemo
//
//  Created by Shilpa Brahme on 19/04/23.
//

import Foundation
import UIKit

protocol CellDataModel {
    
}

class CellWithDataModel: UITableViewCell, CellDataModel {
}

struct ReachablityManager {
    var isInternetAvailable: Bool {
        return true // NetworkReachabilityManager()?.isReachable ?? false
    }
}

struct Helper {
    static func getDayDateTime(format:String, unixTimeStamp: CUnsignedLongLong, showInDeviceTimeZone: Bool = true, timezone: Int) -> String {
       var timeinterval = TimeInterval(unixTimeStamp)
       let epochTime = TimeInterval(unixTimeStamp)
        if (showInDeviceTimeZone) {
            timeinterval = Helper.adjustForLocalTimeZone(unixTimeStamp: unixTimeStamp, timezone: timezone)
        }
       let date = Date(timeIntervalSince1970: epochTime)
       let currentDate = Date.init(timeIntervalSinceReferenceDate: timeinterval)
       let dateFormatter = DateFormatter()
       let timezone = DateTimeConstants.DEFAULT_TIME_ZONE
       dateFormatter.timeZone = TimeZone(abbreviation: timezone)
//       dateFormatter.locale = Locale.autoupdatingCurrent
       dateFormatter.dateFormat = format
       let strDate = dateFormatter.string(from: currentDate)
       let strDate2 = dateFormatter.string(from: date)
       print("\n\n\n date = \(strDate) \n\n currentDate = \(strDate2)")
       return strDate
    }
    
   static func adjustForLocalTimeZone(unixTimeStamp: CUnsignedLongLong, timezone: Int) -> TimeInterval {
       var timeinterval = TimeInterval(unixTimeStamp)
       timeinterval = timeinterval + TimeInterval(timezone)
       return timeinterval
    }
    
}
