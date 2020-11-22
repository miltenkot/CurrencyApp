//
//  CurrencyTableViewCell.swift
//  CurrencyApp
//
//  Created by Bartek Lanczyk on 21/11/2020.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var midLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
