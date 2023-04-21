//
//  CellWithVerticalLabels.swift
//  WeatherAppDemo
//
//  Created by Shilpa Brahme on 19/04/23.
//

import UIKit

class CellWithVerticalLabels: CellWithDataModel {
    
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var cityAndCountryLabel: UILabel!
    var dataModel: CellWithVerticalLabelDataModel? {
        didSet {
            guard let viewModel = dataModel else {
                return
            }
            self.timestampLabel.text = "\(viewModel.titleAtTop ?? "") \(viewModel.textAtTop ?? "")"
            self.cityAndCountryLabel.text = "\(viewModel.titleAtBottom ?? "") \(viewModel.textAtBottom ?? "")"
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
