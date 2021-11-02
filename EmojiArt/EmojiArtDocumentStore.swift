//
//  EmojiArtDocumentStore.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 5/6/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI
import Combine

class EmojiArtDocumentStore: ObservableObject
{
    let name: String
    
    func name(for document: EmojiArtDocumentVM) -> String {
        if documentNames[document] == nil {
            documentNames[document] = "Untitled"
        }
        return documentNames[document]!
    }
    
    func setName(_ name: String, for document: EmojiArtDocumentVM) {
        documentNames[document] = name
    }
    
    var documents: [EmojiArtDocumentVM] {
        documentNames.keys.sorted { documentNames[$0]! < documentNames[$1]! }
    }
    
    func addDocument(named name: String = "Untitled") {
        documentNames[EmojiArtDocumentVM()] = name
    }

    func removeDocument(_ document: EmojiArtDocumentVM) {
        documentNames[document] = nil
    }
    
    @Published private var documentNames = [EmojiArtDocumentVM:String]()
    
    private var autosave: AnyCancellable?
    
    init(named name: String = "Emoji Art") {
        self.name = name
        let defaultsKey = "EmojiArtDocumentStore.\(name)"
        documentNames = Dictionary(fromPropertyList: UserDefaults.standard.object(forKey: defaultsKey))
        if documents.count == 0 {
            addDocument(named: name)
        }
        autosave = $documentNames.sink { names in
            UserDefaults.standard.set(names.asPropertyList, forKey: defaultsKey)
        }
    }
}

extension Dictionary where Key == EmojiArtDocumentVM, Value == String {
    var asPropertyList: [String:String] {
        var uuidToName = [String:String]()
        for (key, value) in self {
            uuidToName[key.id.uuidString] = value
        }
        return uuidToName
    }
    
    init(fromPropertyList plist: Any?) {
        self.init()
        let uuidToName = plist as? [String:String] ?? [:]
        for uuid in uuidToName.keys {
            self[EmojiArtDocumentVM(id: UUID(uuidString: uuid))] = uuidToName[uuid]
        }
    }
}
