import SwiftUI
import PhotosUI

@MainActor
final class PhotosPickerViewModel: ObservableObject {
    
    @Published private(set) var selectedImages: [UIImage] = []
    @Published var imagesSelections: [PhotosPickerItem] = [] {
        didSet {
            Task {
                await setImages(from: imagesSelections)
            }
        }

    }
    
    private func setImages(from selection: [PhotosPickerItem]) async {
        do {
            var images: [UIImage] = []
            for item in selection {
                if let data = try? await item.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        images.append(uiImage)
                    }
                }
            }
            selectedImages = images
        } catch {
            print("Error loading images: \(error)")
        }
    }
    
    func clearSelectedImages() {
        selectedImages.removeAll()
    }

}
