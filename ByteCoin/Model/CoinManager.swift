//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//  https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey={COINAPI_API_KEY}


import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(_ coinManager: CoinManager, coinModel: CoinModel)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate"
    let apiKey = "{COINAPI_API_KEY}"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/BTC/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString, currency: currency)
    }
    
    func performRequest(with urlString: String, currency: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    return print(error as Any)
                }
                let safeData = data!
                let coinPrice = self.parseJSON(coinData: safeData)
                self.delegate?.didUpdatePrice(self, coinModel: coinPrice!)
                
//                if let safeData = data {
//                    if let weather = self.parseJSON(safeData) {
//                        self.delegate?.didUpdateWeather(self, weather: weather)
//                    }
//                }
            }
            task.resume()
        } else {
            print("Something wrong with URL")
        }
    }
    
    func parseJSON(coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let name = decodedData.asset_id_base
            let currency = decodedData.asset_id_quote
            let rate = decodedData.rate
            
            let coin = CoinModel(name: name, currency: currency, rate: rate)
            print(coin.rate)
            return coin
        } catch {
            return nil
        }
    }
    
}
