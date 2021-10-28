//
//  Spinning.swift
//  EmojiArt
//
//  Created by 曾国锐 on 2021/10/28.
//

import SwiftUI

struct Spinning: ViewModifier {
    
    @State var isVisible = false
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: isVisible ? 360 : 0))
            .onAppear {
                isVisible = true
            }
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
    }
}

extension View {
    func spinning() -> some View {
        modifier(Spinning())
    }
}
