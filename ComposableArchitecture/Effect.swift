//
//  Effect.swift
//  ComposableArchitecture
//
//  Created by Voro on 10.02.21.
//

import Foundation

public struct Effect<A> {
    public let run: (@escaping (A) -> Void) -> Void
    
    public init(run: @escaping (@escaping (A) -> Void) -> Void) {
        self.run = run
    }
    
    public func map<B>(_ f: @escaping (A) -> B) -> Effect<B> {
        return Effect<B> { callback in self.run { arg in callback(f(arg))} }
    }
    
    public func receive(on queue: DispatchQueue) -> Effect {
        return Effect { callback in
            self.run { result in
                queue.async {
                    callback(result)
                }
            }
        }
    }
}

extension Effect where A == (Data?, URLResponse?, Error?) {
    public func decode<M: Decodable>(as type: M.Type) -> Effect<M?> {
        return self.map { data, _, _ in
            data.flatMap { try? JSONDecoder().decode(M.self, from: $0) }
        }
    }
}