//
//  ContentView.swift
//  SwiftUI Future Example
//
//  Created by 김우성 on 2022/03/23.
//

import SwiftUI
import Combine

// MARK: - ViewModel (Only Runs Once)
class OnlyRunsOnceViewModel: ObservableObject {
    @Published var first = ""
    @Published var second = ""
    
    let futurePublisher = Future<String, Never> { value in
        value(.success("Start!!!"))
        print("---Start---")
    }
    
    func fetch() {
        futurePublisher
            .assign(to: &$first)
    }
    
    func runAgain() {
        futurePublisher
            .assign(to: &$second)
    }
}


// MARK: - ViewModel
class ContentViewModel: ObservableObject {
    @Published var startMessage = ""
    @Published var exitMessage = ""
    
    var cancellables: AnyCancellable?
    
    func start() {
        Future<String, Never> { value in
            value(Result.success("Start!!"))
        }
        .assign(to: &$startMessage)
    }
    
    func exit() {
        let publisher = Future<String, Never> { value in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                value(.success("Exit"))
            }
        }
        
        cancellables = publisher
            .sink { [unowned self] value in
                self.exitMessage = value
            }
    }
}

// MARK: - View
struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    @StateObject private var onceViewModel = OnlyRunsOnceViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Future Example")
                .font(.title)
            
            HStack {
//                Text("START: ")
//                Text(viewModel.startMessage)
                Text("First: ")
                Text(onceViewModel.first)
            }
            
            HStack {
//                Text("EXIT: ")
//                Text(viewModel.exitMessage)
                Text("Second: ")
                Text(onceViewModel.second)
            }
            
//            Button(action: {
//                viewModel.start()
//            }, label: {
//                Text("START")
//            })
//
//            Button(action: {
//                viewModel.exit()
//            }, label: {
//                Text("EXIT")
//            })
            Button(action: {
                onceViewModel.fetch()
            }, label: {
                Text("Frist")
            })
            
            Button(action: {
                onceViewModel.runAgain()
            }, label: {
                Text("Run Again")
            })
            
        }
        .font(.title2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
