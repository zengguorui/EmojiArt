//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by 曾国锐 on 2021/10/27.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        Group {
            if uiImage != nil {
                Image(uiImage: uiImage!)
            }
        }
    }
}
