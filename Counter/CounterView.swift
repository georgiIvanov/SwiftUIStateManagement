//
//  CounterView.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 23.01.21.
//

import SwiftUI
import ComposableArchitecture
import PrimeModal

private func ordinal(_ n: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    return formatter.string(for: n) ?? ""
}

struct PrimeAlert: Identifiable {
    let prime: Int
    var id: Int {
        self.prime
    }
}

public struct CounterViewState {
    public var count: Int
    public var favoritePrimes: [Int]
    
    public var primeModalViewState: PrimeModalViewState {
        get {
            PrimeModalViewState(count: count, favoritePrimes: favoritePrimes)
        }
        
        set {
            count = newValue.count
            favoritePrimes = newValue.favoritePrimes
        }
    }
    
    public init(count: Int, favoritePrimes: [Int]) {
        self.count = count
        self.favoritePrimes = favoritePrimes
    }
}

public enum CounterViewAction {
    case counter(CounterAction)
    case primeModal(PrimeModalAction)
    
    public var counter: CounterAction? {
        get {
            guard case let .counter(value) = self else { return nil }
            return value
        }
        set {
            guard case .counter = self, let newValue = newValue else { return }
            self = .counter(newValue)
        }
    }

    public var primeModal: PrimeModalAction? {
        get {
            guard case let .primeModal(value) = self else { return nil }
            return value
        }
        set {
            guard case .primeModal = self, let newValue = newValue else { return }
            self = .primeModal(newValue)
        }
    }
}

public struct CounterView: View {
    
    @ObservedObject var store: Store<CounterViewState, CounterViewAction>
    @State var isPrimeModalShown = false
    @State var alertNthPrime: PrimeAlert?
    @State var isNthPrimeButtonDisabled = false

    let webRequests = WebRequestsService()
    
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
            .disabled(self.isNthPrimeButtonDisabled)
        }
        .font(.title)
        .navigationTitle("Counter demo")
        .alert(item: self.$alertNthPrime, content: { (item: PrimeAlert) -> Alert in
            Alert(title: Text("The \(ordinal(store.value.count)) prime is \(item.prime)"),
                  dismissButton: .default(Text("Ok")))
        })
        .sheet(isPresented: self.$isPrimeModalShown) {
            IsPrimeModalView(store: store.view(value: { $0.primeModalViewState },
                                               action: { .primeModal($0) }))
        }
        
    }
    
    func nthPrimeButtonAction() {
        self.isNthPrimeButtonDisabled = true
        webRequests.nthPrime(store.value.count) { (prime) in
            self.isNthPrimeButtonDisabled = false
            self.alertNthPrime = prime.map(PrimeAlert.init(prime:))
        }
    }
}
