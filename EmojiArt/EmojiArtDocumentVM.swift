//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by ζΎε½ι on 2021/10/26.
//

import SwiftUI
import Combine

class EmojiArtDocumentVM: ObservableObject, Hashable, Identifiable {
    static func == (lhs: EmojiArtDocumentVM, rhs: EmojiArtDocumentVM) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: UUID
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static let palette: String = "π¦π¦π¦πππ£ππ©π"
    
    @Published private var emojiArtModel: EmojiArtModel
//    private var emojiArtModel: EmojiArtModel {
//        willSet {
//            objectWillChange.send()
//        }
//        didSet {
//            UserDefaults.standard.set(emojiArtModel.json, forKey: EmojiArtDocumentVM.untitled)
//            print("json = \(emojiArtModel.json?.utf8 ?? "nil")")
//        }
//    }
        
    private var autosaveCancellable: AnyCancellable?
    
    init(id: UUID? = nil) {
        self.id = id ?? UUID()
        let defaultsKey = "EmojiArtDocument.\(self.id.uuidString)"
        emojiArtModel = EmojiArtModel(json: UserDefaults.standard.data(forKey: defaultsKey)) ?? EmojiArtModel()
        autosaveCancellable = $emojiArtModel.sink { emojiArtModel in
            print("json = \(emojiArtModel.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(emojiArtModel.json, forKey: defaultsKey)
        }
        fetchBackgroundImageData()
    }
    
    @Published private(set) var backgroundImage: UIImage?
    
    @Published var steadyStateZoomScale: CGFloat = 1.0
    @Published var steadyStatePanOffset: CGSize = .zero
    
    var emojis: [EmojiArtModel.Emoji] {emojiArtModel.emojis }
    
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArtModel.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArtModel.Emoji, by offset: CGSize) {
        if let index = emojiArtModel.emojis.firstIndex(matching: emoji) {
            emojiArtModel.emojis[index].x += Int(offset.width)
            emojiArtModel.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArtModel.Emoji, by scale: CGFloat) {
        if let index = emojiArtModel.emojis.firstIndex(matching: emoji) {
            emojiArtModel.emojis[index].size = Int((CGFloat(emojiArtModel.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }
    
    var backgroundURL: URL? {
        get {
            emojiArtModel.backgroundURL
        }
        set {
            emojiArtModel.backgroundURL = newValue?.imageURL
            fetchBackgroundImageData()
        }
    }
    
    private var fetchImageCanceller: AnyCancellable?
    
    private func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = emojiArtModel.backgroundURL {
//            DispatchQueue.global(qos: .userInitiated).async {
//                if let imageData = try? Data(contentsOf: url) {
//                    DispatchQueue.main.async {
//                        if url == self.emojiArtModel.backgroundURL {
//                            self.backgroundImage = UIImage(data: imageData)
//                        }
//                    }
//                }
//            }
            fetchImageCanceller?.cancel()
            
            fetchImageCanceller = URLSession.shared.dataTaskPublisher(for: url)
                .map { data, response in
                    UIImage(data: data)
                }
                .receive(on: DispatchQueue.main)
                .replaceError(with: nil)
                .assign(to: \.backgroundImage, on: self)
        }
    }
}

extension EmojiArtModel.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
