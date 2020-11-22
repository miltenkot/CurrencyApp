//
//  CurrencyData.swift
//  CurrencyApp
//
//  Created by Bartek Lanczyk on 21/11/2020.
//

import Foundation

struct RatesResponse: Decodable {
    let rates: [Rates]
    let effectiveDate: String
}

struct Rates: Decodable {
    let currency: String
    let code: String
    let mid: Double
}
