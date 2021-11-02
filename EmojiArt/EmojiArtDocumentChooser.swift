//
//  EmojiArtDocumentChooser.swift
//  EmojiArt
//
//  Created by 曾国锐 on 2021/11/1.
//

import SwiftUI

struct EmojiArtDocumentChooser: View {
    @EnvironmentObject var store: EmojiArtDocumentStore
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.documents) { document in
                    NavigationLink {
                        EmojiArtDocumentView(document: document)
                    } label: {
                        Text(self.store.name(for: document))
                    }
                }
            }
        }
    }
}

struct EmojiArtDocumentChooser_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentChooser().environmentObject(EmojiArtDocumentStore())
    }
}
