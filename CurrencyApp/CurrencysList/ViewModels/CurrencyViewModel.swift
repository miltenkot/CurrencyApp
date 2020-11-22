//
//  CurrencyMainTableViewModel.swift
//  CurrencyApp
//
//  Created by Bartek Lanczyk on 21/11/2020.
//

import Foundation
import RxSwift
import RxCocoa

struct CurrencyViewModel {
    let rates: Rates
    
    var currency: Observable<String> {
        return Observable<String>.just(rates.currency)
    }
    
    var code: Observable<String>{
        return Observable<String>.just(rates.code)
    }
    
    var mid: Observable<String>{
        return Observable<String>.just(String(rates.mid))
    }
    
    init(_ rates: Rates) {
        self.rates = rates
    }
    
}

