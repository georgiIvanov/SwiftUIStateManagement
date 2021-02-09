//
//  WebRequestsService.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 23.01.21.
//

import Foundation
import ComposableArchitecture

class WebRequestsService {
    
    private let wolframAlphaApiKey = "GK6WPH-LWEH8AXQU4"
    
    func nthPrime(_ n: Int) -> Effect<Int?> {
        wolframAlpha(query: "prime \(n)").map { result in
          result
            .flatMap {
              $0.queryresult
                .pods
                .first(where: { $0.primary == .some(true) })?
                .subpods
                .first?
                .plaintext
            }
            .flatMap(Int.init)
      }
    }
    
    func wolframAlpha(query: String) -> Effect<WolframAlphaResult?> {
        var components = URLComponents(string: "https://api.wolframalpha.com/v2/query")!
        components.queryItems = [
            URLQueryItem(name: "input", value: query),
            URLQueryItem(name: "format", value: "plaintext"),
            URLQueryItem(name: "output", value: "JSON"),
            URLQueryItem(name: "appid", value: self.wolframAlphaApiKey),
        ]

        return dataTask(with: components.url(relativeTo: nil)!).decode(as: WolframAlphaResult.self)
    }
    
    func dataTask(with url: URL) -> Effect<(Data?, URLResponse?, Error?)> {
        return Effect { callback in
            URLSession.shared.dataTask(with: url) { data, response, error in
                callback((data, response, error))
            }
            .resume()
        }
    }
}
