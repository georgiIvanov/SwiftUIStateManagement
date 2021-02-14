//
//  WebRequestsService.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 23.01.21.
//

import Foundation
import ComposableArchitecture
import Combine

public class WebRequestsService {
    
    private let wolframAlphaApiKey = "GK6WPH-LWEH8AXQU4"
    
    public static let nthPrime: (Int) -> Effect<Int?> = { number in
        return WebRequestsService().nthPrime(number)
    }
    
    public static let offlineNthPrime: (Int) -> Effect<Int?> = { n in
        Deferred {
            Future { callback in
                var nthPrime = 1
                var count = 0
                while count <= n {
                    nthPrime += 1
                    if isPrime(nthPrime) {
                        count += 1
                    }
                }
                callback(.success(nthPrime))
            }
        }
        .subscribe(on: DispatchQueue.global())
        .receive(on: DispatchQueue.main)
        .eraseToEffect()
    }
    
    private static func isPrime(_ p: Int) -> Bool {
        if p <= 1 { return false }
        if p <= 3 { return true }
        for i in 2...Int(sqrt(Float(p))) {
            if p % i == 0 { return false }
        }
        
        return true
    }
    
    func nthPrime(_ n: Int) -> Effect<Int?> {
        wolframAlpha(query: "prime \(n)").map { result in
            result.flatMap {
                $0.queryresult.pods
                    .first(where: { $0.primary == .some(true) })?
                    .subpods.first?.plaintext
            }
            .flatMap(Int.init)
        }.eraseToEffect()
    }
    
    func wolframAlpha(query: String) -> Effect<WolframAlphaResult?> {
        var components = URLComponents(string: "https://api.wolframalpha.com/v2/query")!
        components.queryItems = [
            URLQueryItem(name: "input", value: query),
            URLQueryItem(name: "format", value: "plaintext"),
            URLQueryItem(name: "output", value: "JSON"),
            URLQueryItem(name: "appid", value: self.wolframAlphaApiKey),
        ]
        
        let publisher = URLSession.shared
            .dataTaskPublisher(for: components.url(relativeTo: nil)!)
            .map { data, _ in data }
            .decode(type: WolframAlphaResult?.self, decoder: JSONDecoder())
            .replaceError(with: nil)
            .eraseToEffect()
        
        
        return publisher
    }
}
