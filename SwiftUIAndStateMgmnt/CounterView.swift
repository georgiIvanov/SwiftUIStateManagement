//
//  CounterView.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 23.01.21.
//

import SwiftUI
import ComposableArchitecture

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

struct CounterViewState {
    var count: Int
    var favoritePrimes: [Int]
    
    var isPrimeModalViewState: IsPrimeModalViewState {
        IsPrimeModalViewState(count: count, favoritePrimes: favoritePrimes)
    }
}

struct CounterView: View {
    
    @ObservedObject var store: Store<CounterViewState, AppAction>
    @State var isPrimeModalShown = false
    @State var alertNthPrime: PrimeAlert?
    @State var isNthPrimeButtonDisabled = false

    let webRequests = WebRequestsService()
    
    var body: some View {
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
            IsPrimeModalView(store: store.view(value: { $0.isPrimeModalViewState },
                                               action: { $0 }))
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
