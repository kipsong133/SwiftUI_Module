//
//  ContentView.swift
//  SwiftUI CurrentValueSubject Example
//
//  Created by 김우성 on 2022/03/23.
//

import SwiftUI
import Combine

// MARK: - ViewModel
class ContentViewModel: ObservableObject {
    var selection = CurrentValueSubject<String, Never>("초기값...")
    var isSameSelection = CurrentValueSubject<Bool, Never>(false)
    var cancellables: [AnyCancellable] = []
    
    init() {
        selection
            .map { [unowned self] newValue -> Bool in
                print("DEBUG: \(newValue)")
                if newValue == selection.value {
                    return true
                } else {
                    return false
                }
            }
            .sink { [unowned self] value in
                print("DEBUG: \(value)")
                isSameSelection.value = value
                /* ViewModel -> View 에게 값이 변경되었음을 알립니다. */
                objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}

// MARK: - View
struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack(spacing: 15) {
            Text("CurrentValueSubject")
                .font(.title)
            
            HStack {
                Text("RESULT: ")
                Text(viewModel.selection.value)
                    .foregroundColor(
                        viewModel.isSameSelection.value ? .green : .red
                    )
            }
            
            Button(action: {
                viewModel.selection.send("UNO")
            }, label: {
                Text("UNO로 변경하기")
                    .font(.system(size: 15))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    )
            })
            
            Button(action: {
                viewModel.selection.send("Moya")
            }, label: {
                Text("Moya로 변경하기")
                    .font(.system(size: 15))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    )
            })
        }
        .foregroundColor(.black)
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
