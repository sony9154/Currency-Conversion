//
//  AccountService.swift
//  GitHubApiDemo
//
//  Created by Hsu Hua on 2021/7/7.
//

import Foundation

class CurrencyService {
    static var shared = CurrencyService()
    
    func getAllCurrencies(completion: @escaping (Result<[Currency], Error>) -> Void) {
        APIService.shared.getSupportedCurrencies { result in
            switch result {
            case .success(let currencies):
                completion(.success(currencies))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getLiveExchange(completion: @escaping (Result<[ExchangeRate], Error>) -> Void) {
        APIService.shared.getLiveExchange { result in
            switch result {
            case .success(var currencies):
                currencies = currencies.compactMap({
                    ExchangeRate(currency: $0.currency?.replacingOccurrences(of: "USD", with: "", options: String.CompareOptions.literal, range: $0.currency?.range(of: "USD")),
                                 rate: $0.rate,
                                 amount: nil)
                })
                .sorted() { $0.currency ?? "" < $1.currency ?? "" }
                completion(.success(currencies))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}
