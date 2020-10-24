//
//  URLRequest+Extensions.swift
//  GoodWeather
//
//  Created by Nurtugan Nuraly on 10/15/20.
//  Copyright © 2020 XFamily, LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

struct Resource<T> {
    let url: URL
}

extension URLRequest {
    /*
    static func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        Observable.from([resource.url])
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            }.map { data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }.asObservable()
    }
    */
    
    static func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        Observable.just(resource.url)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.response(request: request)
            }.map { response, data -> T in
                guard 200..<300 ~= response.statusCode else {
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }
                return try JSONDecoder().decode(T.self, from: data)
            }.asObservable()
    }
}
