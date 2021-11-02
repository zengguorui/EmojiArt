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
    @State private var showPaletteEditor = false
    
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
            Image(systemName: "keyboard")
                .imageScale(.large)
                .popover(isPresented: $showPaletteEditor) {
//                .sheet(isPresented: $showPaletteEditor) {
                    PaletteEditor(chosenPalette: $chosenPalette, isShowing: $showPaletteEditor)
                        .environmentObject(self.document)
                        .frame(minWidth: 300, minHeight: 500)
                }
                .onTapGesture {
                    showPaletteEditor = true
                }
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

struct PaletteEditor: View {
    
    @EnvironmentObject var document: EmojiArtDocumentVM
    @Binding var chosenPalette: String
    @Binding var isShowing: Bool
    @State private var paletteName: String = ""
    @State private var emojisToAdd: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("调色板编辑器")
                    .font(.headline)
                    .padding()
                HStack {
                    Spacer()
                    Button {
                        self.isShowing = false
                    } label: {
                        Text("完成")
                    }
                    .padding()
                }
            }
            
            Divider()
            Form {
                Section {
                    TextField("调色板名称", text: $paletteName, onEditingChanged: { began in
                        if !began {
                            self.document.renamePalette(self.chosenPalette, to: self.paletteName)
                        }
                    })
                    
                    TextField("添加 Emoji", text: $emojisToAdd, onEditingChanged: { began in
                        if !began {
                            self.chosenPalette = self.document.addEmoji(self.emojisToAdd, toPalette: self.chosenPalette)
                            self.emojisToAdd = ""
                        }
                    })
                }
                
                Section(header: Text("删除 Emoji")) {

//                    ForEach(chosenPalette.map { String($0)}, id: \.self){ emoji in
//                        Text(emoji)
//                            .onTapGesture {
//                                self.chosenPalette = self.document.removeEmoji(emoji, fromPalette: self.chosenPalette)
//                            }
//                    }
                    Grid(chosenPalette.map { String($0)}, id: \.self) { emoji in
                        Text(emoji)
                            .font(Font.system(size: self.fontSize))
                            .onTapGesture {
                                self.chosenPalette = self.document.removeEmoji(emoji, fromPalette: self.chosenPalette)
                            }
                    }
                    .frame(height: self.height)
                }
            }
        }
        .onAppear {
            paletteName = self.document.paletteNames[self.chosenPalette] ?? ""
        }
    }
    
    var height: CGFloat {
        CGFloat((chosenPalette.count - 1) / 6) * 70 + 70
    }
    
    let fontSize: CGFloat = 40
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(document: EmojiArtDocumentVM(), chosenPalette: Binding.constant(""))
    }
}
