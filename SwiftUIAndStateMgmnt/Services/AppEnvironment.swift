//
//  AppEnvironment.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 12.02.21.
//

import Foundation
import Counter
import FavoritePrimes
import ComposableArchitecture

typealias AppEnvironment = (
    fileClient: FileClient,
    nthPrime: (Int) -> Effect<Int?>,
    offlineNthPrime: (Int) -> Effect<Int?>,
    log: (String) -> Void
)

let liveEnvironment: AppEnvironment = {
    AppEnvironment(
        fileClient: .live,
        nthPrime: WebRequestsService.nthPrime,
        offlineNthPrime: WebRequestsService.offlineNthPrime,
        log: { (toLog) in
            print(toLog)
        })
}()

var mockEnvironment: AppEnvironment = {
    AppEnvironment(
        fileClient: .mock,
        nthPrime: { _ in .sync { 17 }},
        offlineNthPrime: WebRequestsService.offlineNthPrime,
        log: { (toLog) in
            print(toLog)
        })
}()
