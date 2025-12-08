import SwiftUI
import PhotosUI

struct VaultView: View {
    @StateObject private var store = VaultStore()

    @State private var showCamera = false
    @State private var selectedPickerItem: PhotosPickerItem?
    @State private var selectedPhoto: VaultPhoto?

    var body: some View {
        VStack {
            // Top buttons
            HStack(spacing: 12) {
                PhotosPicker(
                    selection: $selectedPickerItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Label("From Photos", systemImage: "photo.on.rectangle")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(10)
                }

                Button {
                    showCamera = true
                } label: {
                    Label("Use Camera", systemImage: "camera")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(10)
                }
                .disabled(!UIImagePickerController.isSourceTypeAvailable(.camera))
            }
            .padding()

            if store.photos.isEmpty {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "lock.rectangle.on.rectangle")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    Text("No documents yet")
                        .font(.headline)
                    Text("Add photos of important documents to keep them safe and handy.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                Spacer()
            } else {
                ScrollView {
                    let columns = [GridItem(.adaptive(minimum: 110), spacing: 12)]

                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(store.photos) { photo in
                            if let uiImage = store.image(for: photo) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 110)
                                        .frame(maxWidth: .infinity)
                                        .clipped()
                                        .cornerRadius(10)
                                        .onTapGesture {
                                            selectedPhoto = photo
                                        }

                                    Text(photo.createdAt, style: .date)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
        }
        .navigationTitle("Vault")
        // Handle PhotosPicker result (iOS 17 style)
        .onChange(of: selectedPickerItem) { oldValue, newValue in
            guard let newItem = newValue else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    store.addImage(uiImage)
                }
            }
        }
        // Camera sheet
        .sheet(isPresented: $showCamera) {
            CameraPicker { image in
                store.addImage(image)
            }
        }
        // Fullscreen preview + delete
        .sheet(item: $selectedPhoto) { photo in
            VaultPhotoDetail(photo: photo, store: store)
        }
    }
}

struct VaultPhotoDetail: View {
    let photo: VaultPhoto
    @ObservedObject var store: VaultStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Group {
                if let uiImage = store.image(for: photo) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .background(Color.black)
                        .ignoresSafeArea()
                } else {
                    Text("Unable to load image.")
                        .foregroundColor(.secondary)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(role: .destructive) {
                        store.delete(photo)
                        dismiss()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }
}
