//
//  URLRequest+Extensions.swift
//  CurrencyApp
//
//  Created by Bartek Lanczyk on 21/11/2020.
//

import Foundation
import RxSwift
import RxCocoa

struct Resource<T: Decodable> {
    let url: URL
}

//MARK: - URL

extension URLRequest {
    static func load<T>(resource: Resource<T>) -> Observable<T> {
        return Observable.just(resource.url)
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            }.map { data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }
    }
}

//MARK: - String

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: .main, value: "", comment: "")
    }
}
