//
//  CoinData.swift
//  ByteCoin
//
//  Created by Ádám Marton on 22.03.2025.
//  Copyright © 2025 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Decodable {
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}
