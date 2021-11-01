//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by 曾国锐 on 2021/11/1.
//

import SwiftUI

struct PaletteChooser: View {
    
    @ObservedObject var document: EmojiArtDocumentVM
    @Binding var chosenPalette: String
    
    var body: some View {
        HStack {
            Stepper(onIncrement: {
                self.chosenPalette = self.document.palette(after: self.chosenPalette)
            }, onDecrement: {
                self.chosenPalette = self.document.palette(before: self.chosenPalette)
            }) {
                EmptyView()
            }
            Text(self.document.paletteNames[self.chosenPalette] ?? "")
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(document: EmojiArtDocumentVM(), chosenPalette: Binding.constant(""))
    }
}
