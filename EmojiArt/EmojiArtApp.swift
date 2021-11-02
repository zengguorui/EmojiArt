//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by 曾国锐 on 2021/10/26.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    
    var body: some Scene {
        WindowGroup {
//            EmojiArtDocumentView(document: EmojiArtDocumentVM())
            let store = EmojiArtDocumentStore(named: "Emoji Art Demo")
////            store.addDocument(named: "hello world")
            EmojiArtDocumentChooser().environmentObject(store)
        }
    }
}
