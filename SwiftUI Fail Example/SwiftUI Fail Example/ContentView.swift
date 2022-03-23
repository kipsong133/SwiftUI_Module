//
//  ContentView.swift
//  SwiftUI Fail Example
//
//  Created by 김우성 on 2022/03/23.
//

import SwiftUI
import Combine

// MARK: - Error Type
enum InvalidError: String, Error, Identifiable {
    var id: String { rawValue }
    case lessThenZero = "0보다 작은 경우"
    case moreThanOneHundred = "100보다 큰 경우"
}

// MARK: - Validator
class Validators {
    static func validNumberPublisher(_ num: Int) -> AnyPublisher<Int, InvalidError> {
        if num < 0 {
            return Fail(error: InvalidError.lessThenZero)
                .eraseToAnyPublisher()
        } else if num > 100 {
            return Fail(error: InvalidError.moreThanOneHundred)
                .eraseToAnyPublisher()
        }
        return Just(num)
            .setFailureType(to: InvalidError.self)
            .eraseToAnyPublisher()
    }
}

// MARK: - ViewModel
class ContentViewModel: ObservableObject {
    @Published var num = 0
    @Published var error: InvalidError?
    
    func save(_ num: Int) {
        _ = Validators.validNumberPublisher(num)
            .sink { [unowned self] value in
                if case .failure(let error) = value {
                    self.error = error
                }
            } receiveValue: { [unowned self] num in
                self.num = num
            }
    }
}

// MARK: - View
struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var num = ""
    
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Fali Example")
                .font(.title)
                .padding()
            
            TextField("숫자를 입력해주세요", text: $num)
                .keyboardType(UIKeyboardType.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                viewModel.save(Int(num) ?? -1)
            }, label: {
                Text("Save")
            })
            .font(.title)
            .alert(item: $viewModel.error) { error in
                Alert(title: Text("Invalid Age"), message: Text(error.rawValue))
            }
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
