//
//  ContentView.swift
//  Test
//
//  Created by paige shin on 2022/04/16.
//

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
