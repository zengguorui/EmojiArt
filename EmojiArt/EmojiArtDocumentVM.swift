//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by 曾国锐 on 2021/10/26.
//

import SwiftUI
import Combine

class EmojiArtDocumentVM: ObservableObject {
    static let palette: String = "🦆🦉🦇🐝🐞🐣🐓🐩🐛"
    
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
    
    private static let untitled = "EmojiArtDocument.Untitled"
    
    private var autosaveCancellable: AnyCancellable?
    
    init() {
        emojiArtModel = EmojiArtModel(json: UserDefaults.standard.data(forKey: EmojiArtDocumentVM.untitled)) ?? EmojiArtModel()
        autosaveCancellable = $emojiArtModel.sink { emojiArtModel in
            print("json = \(emojiArtModel.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(emojiArtModel.json, forKey: EmojiArtDocumentVM.untitled)
        }
        fetchBackgroundImageData()
    }
    
    @Published private(set) var backgroundImage: UIImage?
    
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
