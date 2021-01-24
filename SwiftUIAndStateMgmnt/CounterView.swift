//
//  CounterView.swift
//  SwiftUIAndStateMgmnt
//
//  Created by Voro on 23.01.21.
//

import SwiftUI

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

struct CounterView: View {
    
    @ObservedObject var state: AppState
    @State var isPrimeModalShown = false
    @State var alertNthPrime: PrimeAlert?
    @State var isNthPrimeButtonDisabled = false

    let webRequests = WebRequestsService()
    
    var body: some View {
        VStack {
            HStack {
                Button(action: { self.state.count -= 1 }) {
                    Text("-")
                }
                Text("\(self.state.count)")
                Button(action: { self.state.count += 1 }) {
                    Text("+")
                }
            }
            Button(action: {
                self.isPrimeModalShown = true
            }) {
                Text("Is this prime?")
            }
            Button(action: self.nthPrimeButtonAction) {
                Text("What is the \(ordinal(self.state.count)) prime?")
            }
            .disabled(self.isNthPrimeButtonDisabled)
        }
        .font(.title)
        .navigationTitle("Counter demo")
        .alert(item: self.$alertNthPrime, content: { (item) -> Alert in
            Alert(title: Text("The \(ordinal(self.state.count)) prime is \(item.prime)"),
                  dismissButton: .default(Text("Ok")))
        })
        .sheet(isPresented: self.$isPrimeModalShown) {
            IsPrimeModalView(state: self.state)
        }
        
    }
    
    func nthPrimeButtonAction() {
        self.isNthPrimeButtonDisabled = true
        webRequests.nthPrime(self.state.count) { (prime) in
            self.isNthPrimeButtonDisabled = false
            self.alertNthPrime = prime.map(PrimeAlert.init(prime:))
        }
    }
}
