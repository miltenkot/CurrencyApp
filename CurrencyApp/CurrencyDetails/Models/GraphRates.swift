//
//  GraphRates.swift
//  CurrencyApp
//
//  Created by Bartek Lanczyk on 22/11/2020.
//

import Foundation

struct GraphRatesResponse: Decodable {
    let rates: [GraphRates]
    let code: String
}

struct GraphRates: Decodable {
    let no: String
    let effectiveDate: String
    let mid: Double
}
