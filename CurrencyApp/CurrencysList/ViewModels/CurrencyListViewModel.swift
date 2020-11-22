//
//  CurrencyListViewModel.swift
//  CurrencyApp
//
//  Created by Bartek Lanczyk on 21/11/2020.
//

import Foundation
import RxSwift
import RxCocoa

struct CurrencyListViewModel {
    
    let ratesViewModel: [CurrencyViewModel]
    let date: String
    
    init(_ date: String, _ rates: [Rates]) {
        self.date = date
        self.ratesViewModel = rates.compactMap(CurrencyViewModel.init)
    }
    
    func ratesAt(_ index: Int) -> CurrencyViewModel {
        return self.ratesViewModel[index]
    }
    
}
