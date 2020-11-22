//
//  CurrenciesGraphViewModel.swift
//  CurrencyApp
//
//  Created by Bartek Lanczyk on 22/11/2020.
//

import Foundation
import RxSwift
import RxCocoa

struct CurrenciesGraphViewModel {
    let rates: GraphRates
    
    var no: Observable<String> {
        return Observable<String>.just(rates.no)
    }
    
    var effectiveDate: Observable<String>{
        return Observable<String>.just(rates.effectiveDate)
    }
    
    var mid: Observable<Double>{
        return Observable<Double>.just(rates.mid)
    }
    
    init(_ rates: GraphRates) {
        self.rates = rates
    }
}

