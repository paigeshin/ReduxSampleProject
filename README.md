# State, Actions, Reducers, Middlewares

```swift
//
//  CountState.swift
//  Test
//
//  Created by paige shin on 2022/04/16.
//

import Foundation
import ReduxStore

struct AppState: ReduxState {
    var countState: CountState = CountState()
}

struct CountState {
    var count: Int = 0
}

struct Increment: Action {}

struct Decrement: Action {}

func appReducer(_ state: AppState, _ action: Action) -> AppState {
    var state: AppState = state
    state.countState = counterReducer(state.countState, action)
    return state
}

func counterReducer(_ state: CountState, _ action: Action) -> CountState {
    var state: CountState = state
    switch action {
    case _ as Increment:
        state.count += 1
    case _ as Decrement:
        state.count -= 1
    default:
        return state
    }
    return state
}

func logMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        print("LOG MIDDLEWARE")
    }
}

struct IncrementAsync: Action { }

func incrementMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
        case _ as IncrementAsync:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                dispatch(Increment())
            }
        default:
            break
        }
    }
}

```

# Root 

```swift
import SwiftUI
import ReduxStore

@main
struct TestApp: App {
    
    @StateObject private var store: Store = Store(reducer: appReducer, state: AppState(), middlewares: [
        logMiddleware(),
        incrementMiddleware()
    ])
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}

```

# View 

```swift
import SwiftUI
import ReduxStore

struct ContentView: View {
    
    @EnvironmentObject var store: Store<AppState>
    
    private struct Props {
        let increment: () -> Void
        let decrement: () -> Void
        let incrementAsync: () -> Void
        let count: Int
    }
    
    private func map() -> Props {
        Props(
            increment: {store.dispatch(action: Increment())},
            decrement: {store.dispatch(action: Decrement())},
            incrementAsync: {store.dispatch(action: IncrementAsync())},
            count: store.state.countState.count
        )
    }
    
    var body: some View {
        let props: Props = map()
        VStack {
            
            Text("\(props.count)")
            
            Button {
                props.incrementAsync()
            } label: {
                Text("Increment Async")
            }
            
            Button {
                props.increment()
            } label: {
                Text("Increment")
            }

            Button {
                props.decrement()
            } label: {
                Text("Decrement")
            }
        }
    }
}
```
