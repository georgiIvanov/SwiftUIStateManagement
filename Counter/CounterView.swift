//
//  CounterView.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 23.01.21.
//

import SwiftUI
import ComposableArchitecture
import PrimeModal
import PrimeAlert
import CasePaths

public typealias CounterState = (
    alertNthPrime: PrimeAlert?,
    count: Int,
    isNthPrimeButtonDisabled: Bool,
    isPrimeModalShown: Bool
)

public struct CounterFeatureState: Equatable {
    public var count: Int
    public var favoritePrimes: [Int]
    public var alertNthPrime: PrimeAlert?
    public var isPrimeModalShown: Bool = false
    public var isNthPrimeButtonDisabled: Bool = false
    
    public var counter: CounterState {
        get {
            return (alertNthPrime, count, isNthPrimeButtonDisabled, isPrimeModalShown)
        }
        
        set {
            (alertNthPrime, count, isNthPrimeButtonDisabled, isPrimeModalShown) = newValue
        }
    }
    
    public var primeModalViewState: PrimeModalViewState {
        get {
            PrimeModalViewState(count: count, favoritePrimes: favoritePrimes)
        }
        
        set {
            count = newValue.count
            favoritePrimes = newValue.favoritePrimes
        }
    }
    
    public init(count: Int = 0,
                favoritePrimes: [Int] = [],
                alertNthPrime: PrimeAlert? = nil,
                isNthPrimeButtonDisabled: Bool = false) {
        self.count = count
        self.favoritePrimes = favoritePrimes
        self.alertNthPrime = alertNthPrime
        self.isNthPrimeButtonDisabled = isNthPrimeButtonDisabled
    }
}

public enum CounterFeatureAction: Equatable {
    case counter(CounterAction)
    case primeModal(PrimeModalAction)
}

public struct CounterView: View {
    struct State: Equatable {
        let alertNthPrime: PrimeAlert?
        let count: Int
        let isNthPrimeButtonDisabled: Bool
        let isPrimeModalShown: Bool
    }
    
    
    let store: Store<CounterFeatureState, CounterFeatureAction>
    @ObservedObject var viewStore: ViewStore<State>
    
    public init(store: Store<CounterFeatureState, CounterFeatureAction>) {
        self.store = store
        self.viewStore = store.scope(value: CounterView.State.init, action: { $0 })
        .view
    }
    
    public var body: some View {
        VStack {
            HStack {
                Button(action: { store.send(.counter(.decrTapped)) }) {
                    Text("-")
                }
                Text("\(viewStore.value.count)")
                Button(action: { store.send(.counter(.incrTapped)) }) {
                    Text("+")
                }
            }
            Button(action: {
                store.send(.counter(.isPrimeButtonTapped))
            }) {
                Text("Is this prime?")
            }
            Button(action: self.nthPrimeButtonAction) {
                Text("What is the \(ordinal(viewStore.value.count)) prime?")
            }
            .disabled(viewStore.value.isNthPrimeButtonDisabled)
        }
        .font(.title)
        .navigationTitle("Counter demo")
        .alert(item: .constant(viewStore.value.alertNthPrime),
               content: { (item: PrimeAlert) -> Alert in
                Alert(title: Text(item.title),
                      dismissButton: .default(Text("Ok"), action: { self.store.send(.counter(.alertDismissButtonTapped)) }))
        })
        .sheet(isPresented: .constant(viewStore.value.isPrimeModalShown)) {
            IsPrimeModalView(store: store.scope(value: { $0.primeModalViewState },
                                               action: { .primeModal($0) }))
        }
        
    }
    
    func nthPrimeButtonAction() {
        store.send(.counter(.nthPrimeButtonTapped))
    }
}

extension CounterView.State {
    init(counterFeature: CounterFeatureState) {
        self.alertNthPrime = counterFeature.alertNthPrime
        self.count = counterFeature.count
        self.isNthPrimeButtonDisabled = counterFeature.isNthPrimeButtonDisabled
        self.isPrimeModalShown = counterFeature.isPrimeModalShown
    }
}
