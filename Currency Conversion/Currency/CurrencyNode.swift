//
//  CurrencyNode.swift
//  Currency Conversion
//
//  Created by Hsu Hua on 2021/8/21.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

class CurrencyNode: Node {
    // MARK: - Store -
    var currencies = RxVar<[Currency]?>(nil)
    var exchangeRates = RxVar<[ExchangeRate]?>(nil)
    var convertedRates = RxVar<[ExchangeRate]?>(nil)
    var newAmounts = RxVar<[Double]?>(nil)
    
    // MARK: - Action -
    enum Action {
        case fetchCurrencies
        case fetchLiveExchange
        case convertAmount(currency: String, amount: Double)
    }
    
    func act(_ action: Action, done: ActionCompletion? = nil) {
        switch action {
        case .fetchCurrencies:
            CurrencyService.shared.getAllCurrencies { [weak self] result in
                switch result {
                case .success(let currencies):
                    self?.currencies.accept(currencies)
                    done?()
                case .failure(let error):
                    print(error)
                }
            }
        case .fetchLiveExchange:
            CurrencyService.shared.getLiveExchange { [weak self] result in
                switch result {
                case .success(let exchangeRates):
                    self?.exchangeRates.accept(exchangeRates)
                    done?()
                case .failure(let error):
                    print(error)
                }
            }
        case .convertAmount(let currency, let amount):

            let usdToSelectedCurrencyRate = exchangeRates.value?.filter({
                $0.currency == currency
            })
            var newExchangeRates: [ExchangeRate]? = exchangeRates.value

            newExchangeRates = newExchangeRates?.map({
                var rate: Double
                if currency == "USD" {
                    rate = $0.rate ?? 1.0
                } else {
                    let selectedRate: Double = usdToSelectedCurrencyRate?.first?.rate ?? 0
                    rate = Double(($0.rate ?? 1.0) / selectedRate )
                }
                return ExchangeRate(currency: $0.currency, rate: rate, amount: rate * amount)
            })
            
            self.exchangeRates.accept(newExchangeRates)
            done?()
        }
    }
    
    
    // MARK: - Setup -
    override func setup() {
        super.setup()
        act(.fetchCurrencies)
        act(.fetchLiveExchange)
    }
    
}
