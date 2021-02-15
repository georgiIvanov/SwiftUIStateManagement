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

public typealias CounterState = (
    alertNthPrime: PrimeAlert?,
    count: Int,
    isNthPrimeButtonDisabled: Bool
)

public struct CounterViewState: Equatable {
    public var count: Int
    public var favoritePrimes: [Int]
    public var alertNthPrime: PrimeAlert?
    public var isNthPrimeButtonDisabled: Bool = false
    
    public var counter: CounterState {
        get {
            return (alertNthPrime, count, isNthPrimeButtonDisabled)
        }
        
        set {
            (alertNthPrime, count, isNthPrimeButtonDisabled) = newValue
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

public enum CounterViewAction: Equatable {
    case counter(CounterAction)
    case primeModal(PrimeModalAction)
}

public struct CounterView: View {
    
    @ObservedObject var store: Store<CounterViewState, CounterViewAction>
    @State var isPrimeModalShown = false
    
    public init(store: Store<CounterViewState, CounterViewAction>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            HStack {
                Button(action: { store.send(.counter(.decrTapped)) }) {
                    Text("-")
                }
                Text("\(store.value.count)")
                Button(action: { store.send(.counter(.incrTapped)) }) {
                    Text("+")
                }
            }
            Button(action: {
                self.isPrimeModalShown = true
            }) {
                Text("Is this prime?")
            }
            Button(action: self.nthPrimeButtonAction) {
                Text("What is the \(ordinal(store.value.count)) prime?")
            }
            .disabled(self.store.value.isNthPrimeButtonDisabled)
        }
        .font(.title)
        .navigationTitle("Counter demo")
        .alert(item: .constant(store.value.alertNthPrime),
               content: { (item: PrimeAlert) -> Alert in
                Alert(title: Text(item.title),
                      dismissButton: .default(Text("Ok"), action: { self.store.send(.counter(.alertDismissButtonTapped)) }))
        })
        .sheet(isPresented: self.$isPrimeModalShown) {
            IsPrimeModalView(store: store.scope(value: { $0.primeModalViewState },
                                               action: { .primeModal($0) }))
        }
        
    }
    
    func nthPrimeButtonAction() {
        store.send(.counter(.nthPrimeButtonTapped))
    }
}

