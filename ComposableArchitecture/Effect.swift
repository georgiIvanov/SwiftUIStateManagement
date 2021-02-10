//
//  Effect.swift
//  ComposableArchitecture
//
//  Created by Voro on 10.02.21.
//

import Foundation
import Combine

/// The effect's only purpose is to ultimately produce an action that is fed back into the store.
/// Even if it errors in some way it still needs to produce an action. The effect publisher itself should not fail.
public struct Effect<Output>: Publisher {
    
    public typealias Failure = Never
    
    let publisher: AnyPublisher<Output, Failure>
    
    public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        publisher.receive(subscriber: subscriber)
    }
}

extension Publisher where Failure == Never {
    /// Publishers come with many operations but they don't return the exact same type they acted upon.
    /// Only something that is conforming to the Publisher protocol.
    /// Use this method to erase any information away and return a simple Effect<Output>
    /// See - https://www.thomasvisser.me/2019/07/04/combine-types/
    public func eraseToEffect() -> Effect<Output> {
        return Effect(publisher: self.eraseToAnyPublisher())
    }
}

// MARK: - Effects

extension Effect {
    public static func fireAndForget(work: @escaping () -> Void) -> Effect {
        return Deferred { () -> Empty<Output, Never> in
            work()
            return Empty(completeImmediately: true)
        }.eraseToEffect()
    }
}
