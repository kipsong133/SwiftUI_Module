//
//  ContentView.swift
//  SwiftUI Empty Example
//
//  Created by 김우성 on 2022/03/23.
//

import SwiftUI
import Combine

struct BombDetectedError: Error, Identifiable {
    let id = UUID()
}

// MARK: - ViewModel
class ContentViewModel: ObservableObject {
    @Published var dataToView: [String] = []
    
    func fetch() {
        let inputData = [
            "첫 번째",
            "두 번째",
            "세 번째",
            "네 번째",
            "🧨",
            "여섯 번째"
        ]
        
        _ = inputData.publisher
            .tryMap { item in
                if item == "🧨" {
                    throw BombDetectedError()
                }
                return item
            }
            .catch { error in
                Empty(completeImmediately: true)
            }
            .sink(receiveValue: { [unowned self] item in
                dataToView.append(item)
            })
    }
}

// MARK: - View
struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Empty")
                .font(.title)
            
            List(viewModel.dataToView, id: \.self) { item in
                Text(item)
                    .font(.body)
                    .foregroundColor(.gray)
                    .onTapGesture {
                        print("DEBUG: \(item)")
                    }
            }
        }
        .onAppear {
            viewModel.fetch()
        }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
