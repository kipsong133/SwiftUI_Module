//
//  ContentView.swift
//  SwiftUI TextEditor Example
//
//  Created by 김우성 on 2022/03/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            Text("텍스트 에디터 (구, TextView")
                .font(.title)
                .foregroundColor(.black)
            
            VStack {
                TextEditor(text: $viewModel.text)
                    .padding()
                Text("\(viewModel.text.count)/200")
                    .foregroundColor(viewModel.countColor)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 22)
                    .padding(.bottom, 10)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.yellow, lineWidth: 1)
            )
            .padding()
            
            
            
            Color.gray
                .frame(height: 44)
                .padding(.horizontal, 22)
                .overlay(
                    Text("개인 신상 및 비밀번호 등과 같은 민감한 정보는\n이곳에 메모하지 마세요.")
                        .font(.system(size: 11))
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                )
            
            Text("작성 내용에 개인 신상 정보(주민등록 번호 등)이\n감지되었습니다. 내용을 확인해주세요.")
                .font(.system(size: 14))
                .foregroundColor(.red)
                .multilineTextAlignment(.leading)
            
            Button(action: {}, label: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.yellow)
                    .frame(height: 54)
                    .padding(.horizontal, 22)
                    .overlay(
                        Text("저장")
                    )
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

