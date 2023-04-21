//
//  CellWithImageAndLabel.swift
//  WeatherAppDemo
//
//  Created by Shilpa Brahme on 19/04/23.
//

import UIKit

class CellWithImageAndLabel: CellWithDataModel {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    var dataModel: CellWithImageAndLabelDataModel? {
        didSet {
            guard let viewModel = dataModel else {
                return
            }
            if viewModel.title?.count != 0 {
                self.temperatureLabel.text = "\(viewModel.title ?? "") \(viewModel.text ?? "")"
            } else {
                self.temperatureLabel.text = "\(viewModel.text ?? "")"
            }
           
           // self.icon.image =  UIImage(systemName: viewModel.conditionName ?? "")
            self.icon.downloaded(from:dataModel?.imageURL ?? "")
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
