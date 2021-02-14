//
//  PrimeAlert.swift
//  PrimeAlert
//
//  Created by Voro on 14.02.21.
//

import Foundation

public struct PrimeAlert: Identifiable, Equatable {
    public let n: Int
    public let prime: Int
    
    public var id: Int {
        self.prime
    }
    
    public init(n: Int, prime: Int) {        
        self.n = n
        self.prime = prime
    }
    
    public var title: String {
        return "The \(ordinal(n)) prime is \(prime)"
    }
}

public func ordinal(_ n: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    return formatter.string(for: n) ?? ""
}
