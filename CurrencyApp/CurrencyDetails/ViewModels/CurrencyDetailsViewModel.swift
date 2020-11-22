//
//  CurrencyDetailsViewModel.swift
//  CurrencyApp
//
//  Created by Bartek Lanczyk on 22/11/2020.
//

import Foundation
import RxSwift
import RxCocoa

struct CurrencyDetailsViewModel {
    
    let ratesGraphViewModel: [CurrenciesGraphViewModel]
    
    init(_ rates: [GraphRates]) {
        self.ratesGraphViewModel = rates.compactMap(CurrenciesGraphViewModel.init)
    }
    
    func ratesAt(_ index: Int) -> CurrenciesGraphViewModel {
        return self.ratesGraphViewModel[index]
    }
}
