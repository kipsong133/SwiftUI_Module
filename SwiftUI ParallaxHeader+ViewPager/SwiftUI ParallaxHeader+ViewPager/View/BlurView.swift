//
//  BlurView.swift
//  SwiftUI ParallaxHeader+ViewPager
//
//  Created by 김우성 on 2022/03/23.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
         
    }
}
