//
//  ContentViewModel.swift
//  SwiftUI TextEditor Example
//
//  Created by 김우성 on 2022/03/23.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    var characterLimit = 200
    @Published var text: String = "" {
        didSet {
            if text.count > characterLimit && oldValue.count <= characterLimit {
                text = oldValue
            }
        }
    }
    @Published var characterCount = 0
    @Published var countColor = Color.black
    
    init() {
        
        $text
            .map { text -> Int in
                return text.count
            }
            .assign(to: &$characterCount)
        
        $characterCount
            .map { [unowned self] count -> Color in
                let eightyPercent = Int(Double(characterLimit) * 0.8)
                if (eightyPercent...characterLimit).contains(count) {
                    return Color.black
                } else if count > characterLimit {
                    return Color.red
                }
                return Color.yellow
            }
            .assign(to: &$countColor)
    }
    
}
