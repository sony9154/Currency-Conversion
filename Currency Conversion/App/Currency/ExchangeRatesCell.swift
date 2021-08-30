//
//  ExchangeRatesCell.swift
//  Currency Conversion
//
//  Created by Hsu Hua on 2021/8/22.
//

import UIKit

class ExchangeRatesCell: UICollectionViewCell {
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    func configure(exchangeRate: ExchangeRate?, newAmount: Double?) {
        
        if let currency = exchangeRate?.currency {
            currencyLabel.text = currency
        }
        
        guard let newAmount = newAmount else { return }
        amountLabel.text = String(format: "%6f", newAmount)
    }
}
