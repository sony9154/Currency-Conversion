//
//  APIService.swift
//  GitHubApiDemo
//
//  Created by Hsu Hua on 2021/7/7.
//

import Foundation
import Alamofire

class APIService {
    static var shared = APIService()
    
    var accessToken: String?
    var idToken: String?
    var refreshToken: String?
    private static var accessKey: String {
        return "20191c4201213252a185d67be5420ff6"
    }
    var baseURL = "http://api.currencylayer.com"
    
    var defaultHeaders: HTTPHeaders = [
        "Content-Type" : "application/json; charset=utf-8"
    ]
    
    func getSupportedCurrencies(completion: @escaping(Result<[Currency], Error>) -> Void) {
        var urlComponents = URLComponents(string: "\(baseURL)/list")!
        urlComponents.queryItems = [
            URLQueryItem(name: "access_key", value: APIService.accessKey)
        ]

        let url = urlComponents.url!
        
        let request = AF.request(url, method: .get,
                                 parameters: nil,
                                 headers: defaultHeaders)
                        .validate(statusCode: 200..<300)
        request.response { response in
            print(response)
            switch response.result {
            case .success(let data):
                guard let data = data,
                      let dictionary = try? JSONSerialization.jsonObject(with: data, options: [])
                                            as? [String: Any] else  {
                    completion(.failure(APIError.error(with: response.data)))
                    return
                }
                guard let currencyData = dictionary["currencies"] as? [String: String] else {
                    completion(.failure(APIError.error(with: response.data)))
                    return
                }
                
                let sortedCurrencies = currencyData.sorted( by: { $0.1 < $1.1 })
                
                var currencies: [Currency]? = [Currency]()
                for currencyData in sortedCurrencies {
                    var currency: Currency? = Currency()
                    currency?.code = currencyData.key
                    currency?.name = currencyData.value
                    guard let currency = currency else { return }
                    currencies?.append(currency)
                }
                guard let currencies = currencies else { return }
                completion(.success(currencies))
                
            case .failure(let error):
                completion(.failure(APIError.error(with: response.data,
                                                   fallback: error)))
            }
        }
    }
    
    
    func getLiveExchange(completion: @escaping(Result<[ExchangeRate], Error>) -> Void) {
        let currencies: [String] = []
        var urlComponents = URLComponents(string: "\(baseURL)/live")!
        urlComponents.queryItems = [
            URLQueryItem(name: "access_key", value: APIService.accessKey)
        ]

        let url = urlComponents.url!
        
        var params: [String: Any] = [:]
        params["currencies"] = currencies
        
        let request = AF.request(url, method: .get,
                                 parameters: params,
                                 headers: defaultHeaders)
                        .validate(statusCode: 200..<300)
        request.response { response in
            print(response)
            switch response.result {
            case .success(let data):
                guard let data = data,
                      let dictionary = try? JSONSerialization.jsonObject(with: data, options: [])
                                            as? [String: Any] else  {
                    completion(.failure(APIError.error(with: response.data)))
                    return
                }
                guard let quotesData = dictionary["quotes"] as? [String: Double] else {
                    completion(.failure(APIError.error(with: response.data)))
                    return
                }
                
//                let sortedExchangeRates = quotesData.sorted( by: { $0.1 < $1.1 })
                
                var exchangeRates: [ExchangeRate]? = [ExchangeRate]()
                for exchangeData in quotesData {
                    var exchangeRate: ExchangeRate? = ExchangeRate()
                    exchangeRate?.currency = exchangeData.key
                    exchangeRate?.rate = exchangeData.value
                    guard let exchangeRate = exchangeRate else { return }
                    exchangeRates?.append(exchangeRate)
                }
                guard let exchangeRates = exchangeRates else { return }
                completion(.success(exchangeRates))
                
            case .failure(let error):
                completion(.failure(APIError.error(with: response.data,
                                                   fallback: error)))
            }
        }
    }
    
}


// MARK: - Type Definitio
enum APIError: String, Error {
    case accessTokenIsNil
    case dataNotFound = "100001"    // 查無資料
    case userNotFound = "200001"    // 用戶不存在
    case undefined
    
    // MARK: - Helpers
    static func apiError(with responseData: Data?) -> APIError? {
        if let data = responseData,
           let dictionary = try? JSONSerialization.jsonObject(with: data, options: [])
                                    as? [String: Any],
           let code = dictionary["code"] as? String,
           let apiError = APIError(rawValue: code) {
            return apiError
        } else {
            return nil
        }
    }
    
    static func error(with responseData: Data?, fallback: Error? = nil) -> Error {
        if let data = responseData,
           let dictionary = try? JSONSerialization.jsonObject(with: data, options: [])
                                    as? [String: Any],
           let code = dictionary["code"] as? String,
           let apiError = APIError(rawValue: code) {
            return apiError
        } else {
            return fallback ?? DummyError()
        }
    }
}

struct DummyError: Error {
}
