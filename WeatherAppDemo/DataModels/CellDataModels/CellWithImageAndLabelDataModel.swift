//
//  CellWithVerticalLabelDataModel.swift
//  WeatherAppDemo
//
//  Created by Shilpa Brahme on 19/04/23.
//

import Foundation

struct CellWithImageAndLabelDataModel: CellDataModel {
    var imageURL: String?
    var title: String? = ""
    var text: String? = ""
    var conditionName: String? = ""
}
