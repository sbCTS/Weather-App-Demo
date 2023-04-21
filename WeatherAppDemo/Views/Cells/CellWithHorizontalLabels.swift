//
//  CellWtihHorizontalLabels.swift
//  WeatherAppDemo
//
//  Created by Shilpa Brahme on 19/04/23.
//

import UIKit

class CellWithHorizontalLabels: CellWithDataModel {
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    var dataModel: CellWithHorizontalLabelsDataModel? {
        didSet {
            guard let viewModel = dataModel else {
                return
            }
            self.firstLabel.text = "\(viewModel.titleLeading ?? "") \(viewModel.textLeading ?? ""). "
            self.secondLabel.text = "\(viewModel.titleTrailing ?? "") \(viewModel.textTrailing ?? ""). "
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
