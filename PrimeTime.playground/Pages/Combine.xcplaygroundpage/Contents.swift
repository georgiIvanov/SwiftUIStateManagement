import ComposableArchitecture
import Dispatch
import Combine

// How async work is done with Effect and GCD

let anIntInTwoSeconds = Effect<Int> { callback in
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        callback(42)
    }
}

//anIntInTwoSeconds.run { number in print(number) }
//
//anIntInTwoSeconds.map { $0 * $0 }.run { number in print(number) }


// Creating an iterator without making a new type that
// conforms to Iterator Protocol, we can't do this with Publisher

var count = 0
let iterator = AnyIterator<Int>.init {
    count += 1
    return count
}

Array(iterator.prefix(10))

// One type that implements Publisher is Future<_,_>
// It is an eager publisher - the moment it's created it starts doing work!
// One way we can make it into a lazy publisher is wrapping it in Deferred
// It is also meant to represent single value, great for web requests

let futureInt = Deferred { Future<Int, Never>.init { callback in
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("Work in future.")
            callback(Result.success(42))
            callback(Result.success(1234))
        }
    }
}

// To get a value out of a Future we have to subscribe to it

futureInt.subscribe(AnySubscriber<Int, Never>.init(
                        receiveSubscription: { (subscribtion) in
                            print("Subscribtion")
                            // Subscribtion can be cancelled at a later time
//                            subscribtion.cancel()
                            subscribtion.request(.unlimited)
                        },
                        receiveValue: { value -> Subscribers.Demand in
                            print("Value", value)
                            return .unlimited
                        },
                        receiveCompletion: { completion in
                            print("Completion", completion)
                        })
)


// A much more convenint way of getting values out of a publisher is the sink method
// it allows to tap only into receive value and completion closure
// you don't get to cancel the subscribtion or control the demand

let cancellable = futureInt.sink { (number) in
    print("Got \(number) from sink.")
}



// A way of sending multiple values to a subscriber is Subject

let passtrhough = PassthroughSubject<Int, Never>.init()
let currentValue = CurrentValueSubject<Int, Never>(2)

let c1 = passtrhough.sink { x in
    print("passthrough", x)
}

let c2 = currentValue.sink { x in
    print("currentValue", x)
}

passtrhough.send(1000)
currentValue.send(5000)
