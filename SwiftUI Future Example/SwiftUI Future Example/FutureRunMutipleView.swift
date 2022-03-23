//
//  FutureRunMutipleView.swift
//  SwiftUI Future Example
//
//  Created by 김우성 on 2022/03/23.
//

import SwiftUI
import Combine

// MARK: - ViewModel
class FutureRunMutipleViewModel: ObservableObject {
    @Published var first: String = ""
    @Published var second: String = ""
    
    let futurePublisher = Deferred {
        Future<String, Never> { value in
            value(.success("Called..."))
            print("DEBUG: Called")
        }
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

struct FutureRunMutipleView: View {
    @StateObject var viewModel = FutureRunMutipleViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("Resunlt First: ")
                Text(viewModel.first)
            }
            
            HStack {
                Text("Resunlt Second: ")
                Text(viewModel.second)
            }
            
            Button(action: {
                viewModel.runAgain()
            }, label: {
                Text("RunAgain")
            })
        }
        .onAppear {
            viewModel.fetch()
        }
    }
}

struct FutureRunMutipleView_Previews: PreviewProvider {
    static var previews: some View {
        FutureRunMutipleView()
    }
}
