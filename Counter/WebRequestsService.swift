//
//  WebRequestsService.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 23.01.21.
//

import Foundation

class WebRequestsService {
    
    private let wolframAlphaApiKey = "GK6WPH-LWEH8AXQU4"
    
    func nthPrime(_ n: Int, callback: @escaping (Int?) -> Void) -> Void {
      wolframAlpha(query: "prime \(n)") { result in
        callback(
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
        )
      }
    }
    
    func wolframAlpha(query: String, callback: @escaping (WolframAlphaResult?) -> Void) -> Void {
      var components = URLComponents(string: "https://api.wolframalpha.com/v2/query")!
      components.queryItems = [
        URLQueryItem(name: "input", value: query),
        URLQueryItem(name: "format", value: "plaintext"),
        URLQueryItem(name: "output", value: "JSON"),
        URLQueryItem(name: "appid", value: wolframAlphaApiKey),
      ]

      URLSession.shared.dataTask(with: components.url(relativeTo: nil)!) { data, response, error in
        callback(
          data
            .flatMap { try? JSONDecoder().decode(WolframAlphaResult.self, from: $0) }
        )
        }
        .resume()
    }
}
