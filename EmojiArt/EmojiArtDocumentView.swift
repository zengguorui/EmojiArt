//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by 曾国锐 on 2021/10/26.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var documennt: EmojiArtDocumengtVM
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(EmojiArtDocumengtVM.palette.map{ String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .font(Font.system(size: defaultEmojiSize))
                            .onDrag { NSItemProvider(object: emoji as NSString) }
                    }
                }
            }
            .padding(.horizontal)
            
            GeometryReader { geomotry in
                ZStack {
                    Color.white
                        .overlay(
                            OptionalImage(uiImage: documennt.backgroundImage)
                        )
                    
                    ForEach(documennt.emojis) { emoji in
                        Text(emoji.text)
                            .font(font(for: emoji))
                            .position(position(for: emoji, in: geomotry.size))
                    }
                }
                .clipped()
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                    var location = geomotry.convert(location, from: .global)
                    location = CGPoint(x: location.x - geomotry.size.width/2, y: location.y - geomotry.size.height/2)
                    print(location)
                    return drop(providers: providers, at: location)
                }
            }
        }
    }
    
    private func font(for emoji: EmojiArtModel.Emoji) -> Font {
        Font.system(size: emoji.fontSize)
    }
    
    private func position(for emoji: EmojiArtModel.Emoji, in size:CGSize) -> CGPoint {
        CGPoint(x: emoji.location.x + size.width/2, y: emoji.location.y + size.height/2)
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool{
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            print("dropped:\(url)")
            documennt.setBackgroundURL(url)
        }

        if !found {
            found = providers.loadObjects(ofType: String.self, using: { string in
                documennt.addEmoji(string, at: location, size: self.defaultEmojiSize)
            })
        }
        
        return found
    }
    
    private let defaultEmojiSize: CGFloat = 40
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(documennt: EmojiArtDocumengtVM())
    }
}

extension EmojiArtModel.Emoji {
    var fontSize: CGFloat {
        CGFloat(size)
    }
    
    var location: CGPoint {
        CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
}
