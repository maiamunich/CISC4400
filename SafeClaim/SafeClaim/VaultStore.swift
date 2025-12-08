import Foundation
import UIKit
import Combine

struct VaultPhoto: Identifiable, Codable, Equatable {
    let id: UUID
    let filename: String
    let createdAt: Date
}

final class VaultStore: ObservableObject {
    @Published private(set) var photos: [VaultPhoto] = []

    private let metadataURL: URL
    private let imagesDirectory: URL

    init() {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.imagesDirectory = docs.appendingPathComponent("VaultImages", isDirectory: true)
        self.metadataURL = docs.appendingPathComponent("vault_photos.json")

        // Ensure directory exists
        try? FileManager.default.createDirectory(at: imagesDirectory, withIntermediateDirectories: true)

        load()
    }

    // MARK: - Public API

    func addImage(_ image: UIImage) {
        let id = UUID()
        let filename = "\(id.uuidString).jpg"
        let url = imagesDirectory.appendingPathComponent(filename)

        guard let data = image.jpegData(compressionQuality: 0.9) else { return }

        do {
            try data.write(to: url, options: .atomic)
            let item = VaultPhoto(id: id, filename: filename, createdAt: Date())
            photos.append(item)
            save()
        } catch {
            print("❌ Failed to save image:", error)
        }
    }

    func image(for photo: VaultPhoto) -> UIImage? {
        let url = imagesDirectory.appendingPathComponent(photo.filename)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    func delete(_ photo: VaultPhoto) {
        let url = imagesDirectory.appendingPathComponent(photo.filename)
        try? FileManager.default.removeItem(at: url)
        photos.removeAll { $0 == photo }
        save()
    }

    // MARK: - Persistence

    private func save() {
        do {
            let data = try JSONEncoder().encode(photos)
            try data.write(to: metadataURL, options: .atomic)
        } catch {
            print("❌ Failed to save metadata:", error)
        }
    }

    private func load() {
        guard let data = try? Data(contentsOf: metadataURL) else { return }
        do {
            photos = try JSONDecoder().decode([VaultPhoto].self, from: data)
        } catch {
            print("❌ Failed to load metadata:", error)
        }
    }
}
